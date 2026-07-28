# Serializers for the chat API
from rest_framework import serializers
from core.models import Conversation, Message


class MessageSerializer(serializers.ModelSerializer):
    """Serializer for Message model."""

    class Meta:
        model = Message
        fields = ['id', 'role', 'content', 'created_at']
        read_only_fields = ['id', 'created_at']


class ConversationSerializer(serializers.ModelSerializer):
    """Serializer for Conversation list (without messages)."""
    message_count = serializers.SerializerMethodField()

    class Meta:
        model = Conversation
        fields = ['id', 'title', 'message_count', 'created_at', 'updated_at']
        read_only_fields = ['id', 'created_at', 'updated_at']

    def get_message_count(self, obj):
        return obj.messages.count()


class ConversationDetailSerializer(ConversationSerializer):
    """Serializer for Conversation detail (includes all messages)."""
    messages = MessageSerializer(many=True, read_only=True)

    class Meta(ConversationSerializer.Meta):
        fields = ConversationSerializer.Meta.fields + ['messages']
