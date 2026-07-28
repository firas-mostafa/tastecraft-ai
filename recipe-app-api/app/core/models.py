# Models for db
import uuid
import os

from django.conf import settings
from django.db import models
from django.contrib.auth.models import (
    AbstractBaseUser, BaseUserManager, PermissionsMixin
)
from django.db.models.signals import post_save
from django.dispatch import receiver



def user_image_file_path(instance, filename):
    ext = os.path.splitext(filename)[1]
    filename = f'{uuid.uuid4()}{ext}'
    return os.path.join('uploads', 'user', filename)


def recipe_image_file_path(instance, filename):
    ext = os.path.splitext(filename)[1]
    filename = f'{uuid.uuid4()}{ext}'
    return os.path.join('uploads', 'recipe', filename)


class UserManager(BaseUserManager):
    """Manager for users"""
    def create_user(self, email, password=None, **extra_fields):
        """Create, save and return a new user"""
        if not email:
            raise ValueError('User must have an email address')
        user = self.model(email=self.normalize_email(email), **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, password):
        """Create, save and return a new superuser"""
        user = self.create_user(email=email, password=password)
        user.is_superuser = True
        user.is_staff = True
        user.save(using=self._db)
        return user


class User(AbstractBaseUser, PermissionsMixin):
    """User in the system"""
    email = models.EmailField(max_length=255, unique=True)
    name = models.CharField(max_length=255)
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    
    objects = UserManager()

    USERNAME_FIELD = 'email'


class Allergy(models.Model):
    """Allergy model for user profiles"""
    name = models.CharField(max_length=255, unique=True)

    def __str__(self):
        return self.name


class Disease(models.Model):
    """Chronic disease/condition model for user profiles"""
    name = models.CharField(max_length=255, unique=True)

    def __str__(self):
        return self.name


class HealthProfile(models.Model):
    """Health profile associated with a User"""
    user = models.OneToOneField(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='healthprofile',
    )
    age = models.PositiveIntegerField(null=True, blank=True)
    height_cm = models.FloatField(null=True, blank=True)
    weight_kg = models.FloatField(null=True, blank=True)
    is_onboarded = models.BooleanField(default=False)
    image = models.ImageField(null=True, upload_to=user_image_file_path)
    allergies = models.ManyToManyField(Allergy, blank=True, related_name='health_profiles')
    diseases = models.ManyToManyField(Disease, blank=True, related_name='health_profiles')
    created_at = models.DateTimeField(auto_now_add=True)
    last_suggested_recipe = models.ForeignKey(
        'Recipe',
        null=True,
        blank=True,
        on_delete=models.SET_NULL,
        related_name='suggested_profiles',
    )
    last_suggested_date = models.DateField(null=True, blank=True)

    def __str__(self):
        return f"Health Profile for {self.user.email}"



class Recipe(models.Model):
    # Recipe objects
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
    )
    title = models.CharField(max_length=255)
    description = models.TextField(blank=True)
    time_minutes = models.IntegerField()
    price = models.DecimalField(max_digits=5, decimal_places=2)
    link = models.CharField(max_length=255, blank=True)
    tags = models.ManyToManyField('Tag')
    ingredients = models.ManyToManyField('Ingredient')
    image = models.ImageField(null=True, upload_to=recipe_image_file_path)
    calories = models.PositiveIntegerField(null=True, blank=True)
    is_liked = models.BooleanField(null=True, blank=True)
    user_note = models.TextField(blank=True, default='')

    def __str__(self):
        return self.title


class Tag(models.Model):
    # Tag objects
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
    )
    name = models.CharField(max_length=255)

    def __str__(self):
        return self.name


class Ingredient(models.Model):
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
    )
    name = models.CharField(max_length=255)

    def __str__(self):
        return self.name


class Conversation(models.Model):
    """Represents a chat session between a user and the AI."""
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='conversations',
    )
    title = models.CharField(max_length=255, blank=True, default='')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-updated_at']

    def __str__(self):
        return f'Conversation {self.id} - {self.user.email}'


class Message(models.Model):
    """A single message inside a Conversation."""
    ROLE_HUMAN = 'human'
    ROLE_AI = 'ai'
    ROLE_CHOICES = [
        (ROLE_HUMAN, 'Human'),
        (ROLE_AI, 'AI'),
    ]

    conversation = models.ForeignKey(
        Conversation,
        on_delete=models.CASCADE,
        related_name='messages',
    )
    role = models.CharField(max_length=10, choices=ROLE_CHOICES)
    content = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['created_at']

    def __str__(self):
        return f'[{self.role}] {self.content[:50]}'


class WeeklyMealPlan(models.Model):
    user = models.OneToOneField(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
    )
    plan_data = models.JSONField(help_text="Stores the 7-day meal plan generated by AI")
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Meal Plan for {self.user.name}"


@receiver(post_save, sender=User)
def create_user_profile(sender, instance, created, **kwargs):
    if created:
        HealthProfile.objects.get_or_create(user=instance)

