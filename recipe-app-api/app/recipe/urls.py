# URL mappings for the recipe app
from django.urls import (
    path,
    include,
)

from rest_framework.routers import DefaultRouter

from recipe import views


router = DefaultRouter()
router.register('recipes', views.RecipeViewSet)
router.register('tags', views.TagViewSet)
router.register('ingredients', views.IngredientViewSet)
router.register('meal-plan', views.WeeklyMealPlanViewSet, basename='meal-plan')

app_name = 'recipe'

urlpatterns = [
    path('', include(router.urls)),
    path('analyze-calories/', views.AnalyzeCaloriesView.as_view(), name='analyze-calories'),
]
