import 'package:recipe_app/data/models/conversation/conversation_model.dart';

abstract class ChatHistoryState {}

class ChatHistoryInitial extends ChatHistoryState {}

class ChatHistoryLoading extends ChatHistoryState {}

class ChatHistoryLoaded extends ChatHistoryState {
  final List<ConversationModel> conversations;
  ChatHistoryLoaded(this.conversations);
}

class ChatHistoryError extends ChatHistoryState {
  final String message;
  ChatHistoryError(this.message);
}

class ChatHistoryDetailLoading extends ChatHistoryState {}

class ChatHistoryDetailLoaded extends ChatHistoryState {
  final ConversationModel conversation;
  ChatHistoryDetailLoaded(this.conversation);
}

class ChatHistoryDetailError extends ChatHistoryState {
  final String message;
  ChatHistoryDetailError(this.message);
}
