"""
URL mappings for the chat API.
"""
from django.urls import path, include
from rest_framework.routers import DefaultRouter

from chat import views

router = DefaultRouter()
router.register('conversations', views.ConversationViewSet)

app_name = 'chat'

urlpatterns = [
    path('', include(router.urls)),
]
