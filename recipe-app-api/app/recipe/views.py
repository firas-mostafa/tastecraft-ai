# Views for the recipe APIs
from drf_spectacular.utils import (
    extend_schema_view,
    extend_schema,
    OpenApiParameter,
    OpenApiTypes,
)
from rest_framework import (
    viewsets,
    mixins,
    status,
)
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.views import APIView
from rest_framework.parsers import JSONParser, MultiPartParser, FormParser

from core.models import (
    Recipe,
    Tag,
    Ingredient,
    WeeklyMealPlan
)

from recipe import serializers
from .ai_services import complete_recipe_with_ai, generate_meal_plan_ai, analyze_calories_ai

@extend_schema_view(
    list=extend_schema(
        parameters=[
            OpenApiParameter('tags', OpenApiTypes.STR, description='Comma separated list of tag IDs to filter'),
            OpenApiParameter('ingredients', OpenApiTypes.STR, description='Comma separated list of ingredient IDs to filter')
        ]
    )
)
class RecipeViewSet(viewsets.ModelViewSet):
    serializer_class = serializers.RecipeDetailSerializer
    queryset = Recipe.objects.all()
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def _prams_to_ints(self, qs):
        return [int(str_id) for str_id in qs.split(',')]

    def get_queryset(self):
        tags = self.request.query_params.get('tags')
        ingredients = self.request.query_params.get('ingredients')
        queryset = self.queryset

        if tags:
            tag_ids = self._prams_to_ints(tags)
            queryset = queryset.filter(tags__id__in=tag_ids)
        if ingredients:
            ingredient_ids = self._prams_to_ints(ingredients)
            queryset = queryset.filter(ingredients__id__in=ingredient_ids)

        return queryset.filter(user=self.request.user).order_by('-id').distinct()

    @action(detail=True, methods=['POST'], url_path='complete-ai')
    def complete_recipe_ai(self, request, pk=None):
        recipe = self.get_object()
        user = request.user
        try:
            complete_recipe_with_ai(recipe, user)
            serializer = self.get_serializer(recipe)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
            error_msg = str(e)
            if "429" in error_msg or "quota" in error_msg.lower():
                return Response({"error": "لقد تجاوزت الحد الأقصى المجاني للاستخدام اليومي للذكاء الاصطناعي. يرجى المحاولة غداً أو التحقق من حساب Google الخاص بك."}, status=status.HTTP_429_TOO_MANY_REQUESTS)
            elif "503" in error_msg or "UNAVAILABLE" in error_msg or "high demand" in error_msg.lower():
                return Response({"error": "مساعد الطاهي الذكي مشغول حالياً بسبب كثرة الطلبات على الخوادم. يرجى الانتظار ثوانٍ قليلة وإعادة المحاولة."}, status=status.HTTP_503_SERVICE_UNAVAILABLE)
            return Response({"error": f"Failed to complete recipe: {error_msg}"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    @action(detail=False, methods=['GET'], url_path='suggest')
    def suggest(self, request):
        from django.utils import timezone
        from core.models import HealthProfile
        from .ai_services import suggest_recipe_ai
        
        user = request.user
        profile, _ = HealthProfile.objects.get_or_create(user=user)
        today = timezone.now().date()
        
        if profile.last_suggested_date == today and profile.last_suggested_recipe:
            recipe = profile.last_suggested_recipe
        else:
            try:
                recipe = suggest_recipe_ai(user)
                profile.last_suggested_recipe = recipe
                profile.last_suggested_date = today
                profile.save()
            except Exception as e:
                error_msg = str(e)
                if "429" in error_msg or "quota" in error_msg.lower():
                    return Response({"error": "لقد تجاوزت الحد الأقصى المجاني للاستخدام اليومي للذكاء الاصطناعي. يرجى المحاولة غداً أو التحقق من حساب Google الخاص بك."}, status=status.HTTP_429_TOO_MANY_REQUESTS)
                elif "503" in error_msg or "UNAVAILABLE" in error_msg or "high demand" in error_msg.lower():
                    return Response({"error": "مساعد الطاهي الذكي مشغول حالياً بسبب كثرة الطلبات على الخوادم. يرجى الانتظار ثوانٍ قليلة وإعادة المحاولة."}, status=status.HTTP_503_SERVICE_UNAVAILABLE)
                return Response({"error": f"Failed to suggest recipe: {error_msg}"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
                
        serializer = self.get_serializer(recipe)
        return Response(serializer.data, status=status.HTTP_200_OK)

    def get_serializer_class(self):
        if self.action == 'list':
            return serializers.RecipeSerializer
        elif self.action == 'upload_image':
            return serializers.RecipeImageSerializer
        return self.serializer_class

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

    @action(methods=['POST'], detail=True, url_path='upload-image')
    def upload_image(self, request, pk=None):
        recipe = self.get_object()
        serializer = self.get_serializer(recipe, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@extend_schema_view(
    list=extend_schema(
        parameters=[
            OpenApiParameter('assigned_only', OpenApiTypes.INT, enum=[0, 1], description='Filter by items assigned to recipe'),
        ]
    )
)
class BaseRecipeAttrViewSet(
        mixins.DestroyModelMixin,
        mixins.UpdateModelMixin,
        mixins.ListModelMixin,
        viewsets.GenericViewSet):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        assigned_only = bool(int(self.request.query_params.get('assigned_only', 0)))
        queryset = self.queryset
        if assigned_only:
            queryset = queryset.filter(recipe__isnull=False)
        return queryset.filter(user=self.request.user).order_by('-name').distinct()


class TagViewSet(BaseRecipeAttrViewSet):
    serializer_class = serializers.TagSerializer
    queryset = Tag.objects.all()


class IngredientViewSet(BaseRecipeAttrViewSet):
    serializer_class = serializers.IngredientSerializer
    queryset = Ingredient.objects.all()


class WeeklyMealPlanViewSet(viewsets.GenericViewSet):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]
    
    def list(self, request):
        try:
            plan = WeeklyMealPlan.objects.get(user=request.user)
            return Response(plan.plan_data)
        except WeeklyMealPlan.DoesNotExist:
            return Response({"error": "No meal plan found"}, status=status.HTTP_404_NOT_FOUND)

    @action(methods=['POST'], detail=False, url_path='generate')
    def generate(self, request):
        user = request.user
        health_profile = getattr(user, 'healthprofile', None)
        if not health_profile or not health_profile.height_cm or not health_profile.weight_kg:
            return Response({"error": "Please complete your health profile first."}, status=status.HTTP_400_BAD_REQUEST)
        
        custom_prompt = request.data.get('prompt', '')
        google_fit_steps = request.data.get('google_fit_steps')
        google_fit_calories = request.data.get('google_fit_calories')
        google_fit_data = None
        if google_fit_steps is not None or google_fit_calories is not None:
            google_fit_data = {
                'steps': google_fit_steps or 0,
                'calories': google_fit_calories or 0
            }
        try:
            plan_data = generate_meal_plan_ai(user, custom_prompt, google_fit_data)
            plan, created = WeeklyMealPlan.objects.update_or_create(
                user=user,
                defaults={'plan_data': plan_data}
            )
            return Response(plan.plan_data, status=status.HTTP_200_OK)
        except Exception as e:
            import traceback
            traceback.print_exc()
            error_msg = str(e)
            if "429" in error_msg or "quota" in error_msg.lower():
                return Response({"error": "لقد تجاوزت الحد الأقصى المجاني للاستخدام اليومي للذكاء الاصطناعي. يرجى المحاولة غداً أو التحقق من حساب Google الخاص بك."}, status=status.HTTP_429_TOO_MANY_REQUESTS)
            elif "503" in error_msg or "UNAVAILABLE" in error_msg or "high demand" in error_msg.lower():
                return Response({"error": "مساعد الطاهي الذكي مشغول حالياً بسبب كثرة الطلبات على الخوادم. يرجى الانتظار ثوانٍ قليلة وإعادة المحاولة."}, status=status.HTTP_503_SERVICE_UNAVAILABLE)
            return Response({"error": f"Failed to generate meal plan: {error_msg}"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    @action(methods=['GET'], detail=False, url_path='ai-notes')
    def ai_notes(self, request):
        from .ai_services import generate_meal_plan_notes_ai
        try:
            plan = WeeklyMealPlan.objects.get(user=request.user)
        except WeeklyMealPlan.DoesNotExist:
            return Response({"error": "No meal plan found"}, status=status.HTTP_404_NOT_FOUND)
        
        language = request.query_params.get('lang', 'ar')
        try:
            notes = generate_meal_plan_notes_ai(request.user, plan.plan_data, language)
            return Response({"notes": notes}, status=status.HTTP_200_OK)
        except Exception as e:
            error_msg = str(e)
            if "429" in error_msg or "quota" in error_msg.lower():
                return Response({"error": "لقد تجاوزت الحد الأقصى المجاني للاستخدام اليومي للذكاء الاصطناعي. يرجى المحاولة غداً أو التحقق من حساب Google الخاص بك."}, status=status.HTTP_429_TOO_MANY_REQUESTS)
            elif "503" in error_msg or "UNAVAILABLE" in error_msg or "high demand" in error_msg.lower():
                return Response({"error": "مساعد الطاهي الذكي مشغول حالياً بسبب كثرة الطلبات على الخوادم. يرجى الانتظار ثوانٍ قليلة وإعادة المحاولة."}, status=status.HTTP_503_SERVICE_UNAVAILABLE)
            return Response({"error": f"Failed to generate meal plan notes: {error_msg}"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class AnalyzeCaloriesView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]
    parser_classes = [JSONParser, MultiPartParser, FormParser]

    def post(self, request):
        import base64
        
        image_input = request.FILES.get('image') or request.data.get('image')
        base64_image = None

        if image_input:
            if hasattr(image_input, 'read'):
                # It is an uploaded file
                try:
                    file_bytes = image_input.read()
                    base64_image = base64.b64encode(file_bytes).decode('utf-8')
                except Exception as e:
                    return Response({"error": f"Failed to read uploaded file: {str(e)}"}, status=status.HTTP_400_BAD_REQUEST)
            elif isinstance(image_input, str):
                # It is a base64 string
                base64_image = image_input

        if not base64_image:
            return Response({"error": "No image provided"}, status=status.HTTP_400_BAD_REQUEST)

        language = request.data.get('language', 'en')
        try:
            result = analyze_calories_ai(base64_image, language)
            return Response({"result": result}, status=status.HTTP_200_OK)
        except Exception as e:
            error_msg = str(e)
            if "429" in error_msg or "quota" in error_msg.lower():
                return Response({"error": "لقد تجاوزت الحد الأقصى المجاني للاستخدام اليومي للذكاء الاصطناعي. يرجى المحاولة غداً أو التحقق من حساب Google الخاص بك."}, status=status.HTTP_429_TOO_MANY_REQUESTS)
            elif "503" in error_msg or "UNAVAILABLE" in error_msg or "high demand" in error_msg.lower():
                return Response({"error": "مساعد الطاهي الذكي مشغول حالياً بسبب كثرة الطلبات على الخوادم. يرجى الانتظار ثوانٍ قليلة وإعادة المحاولة."}, status=status.HTTP_503_SERVICE_UNAVAILABLE)
            return Response({"error": f"Failed to analyze calories: {error_msg}"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
