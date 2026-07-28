import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:recipe_app/helpers/responsive/size_helper_extension.dart';
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart';
import 'package:recipe_app/presentation/ai_chat/logic/chat_history_cubit/chat_history_cubit.dart';
import 'package:recipe_app/presentation/ai_chat/logic/chat_history_cubit/chat_history_state.dart';

void showChatHistoryBottomSheet(
  BuildContext context,
  ChatHistoryCubit chatHistoryCubit,
  Function(int) onLoadOldConversation,
) {
  chatHistoryCubit.fetchConversations();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.colorScheme.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(context.setMineSize(20)),
      ),
    ),
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        builder: (context, scrollController) {
          return BlocBuilder<ChatHistoryCubit, ChatHistoryState>(
            bloc: chatHistoryCubit,
            builder: (context, state) {
              if (state is ChatHistoryLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ChatHistoryError) {
                return Center(
                  child: Text(
                    state.message,
                    style: TextStyle(color: context.colorScheme.error),
                  ),
                );
              } else if (state is ChatHistoryLoaded) {
                if (state.conversations.isEmpty) {
                  return const Center(child: Text('No chat history found.'));
                }
                return ListView.builder(
                  controller: scrollController,
                  itemCount: state.conversations.length,
                  itemBuilder: (context, index) {
                    final conv = state.conversations[index];
                    DateTime? parsedDate;
                    try {
                      parsedDate = DateTime.parse(conv.updatedAt);
                    } catch (_) {}
                    final dateStr = parsedDate != null
                        ? DateFormat('MMM d, yyyy - h:mm a').format(parsedDate)
                        : '';
                    return ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: context.colorScheme.primary.withAlpha(20),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.chat_bubble_outline_rounded,
                          color: context.colorScheme.primary,
                        ),
                      ),
                      title: Text(
                        conv.title.isNotEmpty ? conv.title : 'Chat ${conv.id}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle:
                          Text('$dateStr  •  ${conv.messageCount} messages'),
                      onTap: () {
                        Navigator.pop(context);
                        onLoadOldConversation(conv.id);
                      },
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          );
        },
      );
    },
  );
}
