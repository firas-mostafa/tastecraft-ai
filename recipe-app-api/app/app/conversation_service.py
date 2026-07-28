from channels.db import database_sync_to_async
from core.models import Conversation, Message

@database_sync_to_async
def create_conversation(user, first_prompt):
    """Create a new Conversation record in the database."""
    return Conversation.objects.create(
        user=user,
        title=first_prompt[:100],
    )

@database_sync_to_async
def get_conversation_with_messages(conversation_id, user):
    try:
        conv = Conversation.objects.get(id=conversation_id, user=user)
        messages = list(conv.messages.all().order_by('created_at'))
        return conv, messages
    except Conversation.DoesNotExist:
        return None, []

@database_sync_to_async
def save_message(conversation, role, content):
    """Persist a single Message to the database."""
    return Message.objects.create(
        conversation=conversation,
        role=role,
        content=content,
    )

@database_sync_to_async
def set_conversation_title(conversation, title):
    """Update the conversation title."""
    conversation.title = title
    conversation.save(update_fields=['title'])
