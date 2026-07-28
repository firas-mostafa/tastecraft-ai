# Django admin customizqtion
from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from django.utils.translation import gettext_lazy as _
from core import models


class UserAdmin(BaseUserAdmin):
    # Define the admin pages for users
    ordering = ['id']
    list_display = ['email', 'name']
    fieldsets = (
        (None, {'fields': ('email', 'password')}),
        (
            _('Permissions'),
            {'fields': (
                'is_active',
                'is_superuser',
                'is_staff',
            )}
        ),
        (_('Important dates'), {'fields': ('last_login',)}),
    )
    readonly_fields = ['last_login']
    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': (
                'email',
                'name',
                'password1',
                'password2',
                'is_staff',
                'is_superuser',
                'is_active',
            ),
        }),
    )


@admin.register(models.Recipe)
class RecipeAdmin(admin.ModelAdmin):
    list_display = ('title', 'user', 'price', 'calories', 'is_liked')
    list_filter = ('is_liked', 'tags')
    search_fields = ('title', 'user__email')

@admin.register(models.HealthProfile)
class HealthProfileAdmin(admin.ModelAdmin):
    list_display = ('user', 'age', 'height_cm', 'weight_kg', 'is_onboarded', 'last_suggested_date')
    list_filter = ('is_onboarded',)
    search_fields = ('user__email', 'user__name')

@admin.register(models.WeeklyMealPlan)
class WeeklyMealPlanAdmin(admin.ModelAdmin):
    list_display = ('user', 'created_at')
    search_fields = ('user__email', 'user__name')

@admin.register(models.Conversation)
class ConversationAdmin(admin.ModelAdmin):
    list_display = ('user', 'title', 'created_at', 'updated_at')
    list_filter = ('created_at', 'updated_at')
    search_fields = ('user__email', 'title')

@admin.register(models.Message)
class MessageAdmin(admin.ModelAdmin):
    list_display = ('conversation', 'role', 'created_at', 'content_snippet')
    list_filter = ('role', 'created_at')
    search_fields = ('content', 'conversation__user__email')

    def content_snippet(self, obj):
        return obj.content[:60] + '...' if len(obj.content) > 60 else obj.content
    content_snippet.short_description = 'Content'

admin.site.register(models.User, UserAdmin)
admin.site.register(models.Tag)
admin.site.register(models.Ingredient)
admin.site.register(models.Allergy)
admin.site.register(models.Disease)





