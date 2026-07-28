import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/core/api/api_consumer.dart';
import 'package:recipe_app/core/api/end_ponits.dart';
import 'package:recipe_app/data/models/conversation/conversation_model.dart';
import 'chat_history_state.dart';

class ChatHistoryCubit extends Cubit<ChatHistoryState> {
  final ApiConsumer api;

  ChatHistoryCubit(this.api) : super(ChatHistoryInitial());

  Future<void> fetchConversations() async {
    emit(ChatHistoryLoading());
    try {
      final response = await api.get(EndPoint.conversations);
      if (response is List) {
        final conversations = response
            .map((json) => ConversationModel.fromJson(json))
            .toList();
        emit(ChatHistoryLoaded(conversations));
      } else {
        emit(ChatHistoryError('Unexpected response format.'));
      }
    } catch (e) {
      emit(ChatHistoryError(e.toString()));
    }
  }

  Future<void> fetchConversationDetail(int id) async {
    emit(ChatHistoryDetailLoading());
    try {
      final response = await api.get(EndPoint.conversationByID(id));
      if (response is Map<String, dynamic>) {
        final conversation = ConversationModel.fromJson(response);
        emit(ChatHistoryDetailLoaded(conversation));
      } else {
        emit(ChatHistoryDetailError('Unexpected response format.'));
      }
    } catch (e) {
      emit(ChatHistoryDetailError(e.toString()));
    }
  }
}
