from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import user_passes_test
from django.db.models import Avg
from core import models

def superuser_required(view_func):
    """Decorator to require user to be a logged-in superuser."""
    actual_decorator = user_passes_test(
        lambda u: u.is_active and u.is_superuser,
        login_url='portal_login'
    )
    return actual_decorator(view_func)

def onboarding(request):
    """Render the beautiful root onboarding page."""
    if request.user.is_authenticated and request.user.is_superuser:
        return redirect('portal_dashboard')
    return render(request, 'core/onboarding.html')

def portal_login(request):
    """Handle superuser login."""
    if request.user.is_authenticated and request.user.is_superuser:
        return redirect('portal_dashboard')
        
    error = None
    if request.method == 'POST':
        email = request.POST.get('email')
        password = request.POST.get('password')
        
        user = authenticate(request, email=email, password=password)
        if user is not None:
            if user.is_superuser:
                login(request, user)
                return redirect('portal_dashboard')
            else:
                error = "Access denied: Account is not a superuser."
        else:
            error = "Invalid email or password."
            
    return render(request, 'core/login.html', {'error': error})

@superuser_required
def portal_dashboard(request):
    """Calculate stats and render the custom admin dashboard."""
    # 1. User stats
    total_users = models.User.objects.count()
    onboarded_users = models.HealthProfile.objects.filter(is_onboarded=True).count()
    onboarding_rate = (onboarded_users / total_users * 100) if total_users > 0 else 0

    # 2. Health Specs
    health_stats = models.HealthProfile.objects.filter(is_onboarded=True).aggregate(
        avg_age=Avg('age'),
        avg_height=Avg('height_cm'),
        avg_weight=Avg('weight_kg')
    )
    avg_age = health_stats['avg_age'] or 0
    avg_height = health_stats['avg_height'] or 0
    avg_weight = health_stats['avg_weight'] or 0

    profiles_with_bmi = models.HealthProfile.objects.filter(
        is_onboarded=True, height_cm__gt=0, weight_kg__gt=0
    )
    bmis = [p.weight_kg / ((p.height_cm / 100) ** 2) for p in profiles_with_bmi]
    avg_bmi = sum(bmis) / len(bmis) if bmis else 0

    # 3. Recipe stats
    total_recipes = models.Recipe.objects.count()
    liked_recipes = models.Recipe.objects.filter(is_liked=True).count()
    recipes_with_notes = models.Recipe.objects.exclude(user_note='').exclude(user_note__isnull=True).count()
    avg_calories = models.Recipe.objects.aggregate(avg_cal=Avg('calories'))['avg_cal'] or 0

    # 4. Usage activity
    total_meal_plans = models.WeeklyMealPlan.objects.count()
    total_conversations = models.Conversation.objects.count()
    total_messages = models.Message.objects.count()

    # 5. Diseases Breakdown
    diseases_breakdown = []
    for d in models.Disease.objects.all():
        count = d.health_profiles.count()
        if count > 0:
            diseases_breakdown.append({'name': d.name, 'count': count})
    diseases_breakdown = sorted(diseases_breakdown, key=lambda x: x['count'], reverse=True)

    # 6. Allergies Breakdown
    allergies_breakdown = []
    for a in models.Allergy.objects.all():
        count = a.health_profiles.count()
        if count > 0:
            allergies_breakdown.append({'name': a.name, 'count': count})
    allergies_breakdown = sorted(allergies_breakdown, key=lambda x: x['count'], reverse=True)

    stats = {
        'total_users': total_users,
        'onboarded_users': onboarded_users,
        'onboarding_rate': round(onboarding_rate, 1),
        'avg_age': round(avg_age, 1),
        'avg_height': round(avg_height, 1),
        'avg_weight': round(avg_weight, 1),
        'avg_bmi': round(avg_bmi, 1),
        'total_recipes': total_recipes,
        'liked_recipes': liked_recipes,
        'recipes_with_notes': recipes_with_notes,
        'avg_calories': round(avg_calories, 1),
        'total_meal_plans': total_meal_plans,
        'total_conversations': total_conversations,
        'total_messages': total_messages,
        'diseases': diseases_breakdown,
        'allergies': allergies_breakdown,
    }
    
    # 7. Recent user list
    recent_users = models.User.objects.order_by('-id')[:5]

    return render(request, 'core/dashboard.html', {
        'stats': stats,
        'recent_users': recent_users,
    })

def portal_logout(request):
    """Handle logout and redirect to onboarding."""
    logout(request)
    return redirect('onboarding')
