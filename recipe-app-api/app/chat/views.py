# Views for chat API
from rest_framework import viewsets, mixins
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated

from core.models import Conversation
from chat import serializers


class ConversationViewSet(mixins.ListModelMixin,
                          mixins.RetrieveModelMixin,
                          mixins.DestroyModelMixin,
                          viewsets.GenericViewSet):
    """View to manage chat conversations."""
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]
    queryset = Conversation.objects.all()
    serializer_class = serializers.ConversationDetailSerializer

    def get_queryset(self):
        """Retrieve conversations for authenticated user."""
        return self.queryset.filter(user=self.request.user)

    def get_serializer_class(self):
        """Return appropriate serializer class."""
        if self.action == 'list':
            return serializers.ConversationSerializer
        return self.serializer_class
