import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:recipe_app/core/api/dio_consumer.dart';
import 'package:recipe_app/helpers/responsive/size_helper_extension.dart';
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart';
import 'package:recipe_app/l10n/app_localizations.dart';
import 'package:recipe_app/presentation/ai_chat/logic/chat_history_cubit/chat_history_cubit.dart';
import 'package:recipe_app/presentation/ai_chat/logic/ai_chat_cubit/ai_chat_cubit.dart';
import 'package:recipe_app/presentation/ai_chat/logic/ai_chat_cubit/ai_chat_state.dart';
import 'package:recipe_app/presentation/ai_chat/widgets/chat_bubble.dart';
import 'package:recipe_app/presentation/ai_chat/widgets/chat_empty_view.dart';
import 'package:recipe_app/presentation/ai_chat/widgets/chat_input_area.dart';
import 'package:recipe_app/presentation/ai_chat/widgets/chat_app_bar.dart';
import 'package:recipe_app/presentation/ai_chat/widgets/chat_history_bottom_sheet.dart';
import 'package:image_picker/image_picker.dart' show ImageSource;

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  late ChatHistoryCubit _chatHistoryCubit;
  late AiChatCubit _aiChatCubit;
  
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _chatHistoryCubit = ChatHistoryCubit(DioConsumer(dio: Dio()));
    _aiChatCubit = AiChatCubit(_chatHistoryCubit);
  }

  @override
  void dispose() {
    _aiChatCubit.close();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showImageSourceBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.setMineSize(20)),
        ),
      ),
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_rounded),
                title: Text(l10n.aiChatPhotoGallery),
                onTap: () {
                  Navigator.pop(context);
                  _aiChatCubit.pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_rounded),
                title: Text(l10n.aiChatCamera),
                onTap: () {
                  Navigator.pop(context);
                  _aiChatCubit.pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _sendMessage({String? customText}) {
    final String text = customText ?? _textController.text.trim();
    if (text.isEmpty && _aiChatCubit.state.selectedImage == null) return;

    if (customText == null) {
      _textController.clear();
      setState(() {});
    }

    _aiChatCubit.sendMessage(text, onRestoreInput: (restoredText, image) {
       _textController.text = restoredText;
       setState(() {});
    });
  }

  List<String> _getSuggestions(AppLocalizations l10n) {
    return [
      l10n.aiChatSuggestion1,
      l10n.aiChatSuggestion2,
      l10n.aiChatSuggestion3,
      l10n.aiChatSuggestion4,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<AiChatCubit, AiChatState>(
      bloc: _aiChatCubit,
      listenWhen: (previous, current) {
         if (previous.messages.length != current.messages.length ||
             (previous.isStreaming && !current.isStreaming)) {
           return true;
         }
         return previous.errorMessage != current.errorMessage;
      },
      listener: (context, state) {
        if (state.errorMessage != null && !state.isConnecting) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: context.colorScheme.error,
            ),
          );
        }
        _scrollToBottom();
      },
      builder: (context, state) {
        return Scaffold(
          appBar: ChatAppBar(
            isConnected: state.isConnected,
            isConnecting: state.isConnecting,
            onHistoryPressed: () {
              showChatHistoryBottomSheet(
                context,
                _chatHistoryCubit,
                (id) => _aiChatCubit.loadOldConversation(
                  id, 
                  (error) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)))
                ),
              );
            },
          ),
          body: Column(
            children: [
              // Error bar if offline and not connecting
              if (!state.isConnected && !state.isConnecting && state.errorMessage != null)
                Container(
                  color: context.colorScheme.errorContainer,
                  padding: EdgeInsets.symmetric(
                    horizontal: context.setMineSize(16),
                    vertical: context.setMineSize(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          state.errorMessage!,
                          style: TextStyle(
                            color: context.colorScheme.onErrorContainer,
                            fontSize: context.setMineSize(12),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: _aiChatCubit.connectWebSocket,
                        child: Text(
                          'Retry',
                          style: TextStyle(
                            color: context.colorScheme.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              Expanded(
                child: state.messages.isEmpty
                    ? ChatEmptyView(
                        suggestions: _getSuggestions(l10n),
                        onSuggestionSelected: (suggestion) =>
                            _sendMessage(customText: suggestion),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.all(context.setMineSize(16)),
                        itemCount: state.messages.length,
                        itemBuilder: (context, index) {
                          final message = state.messages[index];
                          return ChatBubble(
                            message: message,
                            isStreaming: state.isStreaming && index == state.messages.length - 1,
                          );
                        },
                      ),
              ),
              ChatInputArea(
                textController: _textController,
                selectedImage: state.selectedImage,
                isStreaming: state.isStreaming,
                isListening: state.isListening,
                onShowImageSource: _showImageSourceBottomSheet,
                onRemoveImage: _aiChatCubit.removeSelectedImage,
                onSendMessage: _sendMessage,
                onStartListening: () => _aiChatCubit.startListening(
                  (error) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error))),
                ),
                onStopListening: () => _aiChatCubit.stopListening(
                  (error) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error))),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ],
          ),
        );
      },
    );
  }
}
