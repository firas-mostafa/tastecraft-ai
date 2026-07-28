import 'package:image_picker/image_picker.dart';
import 'package:recipe_app/presentation/ai_chat/widgets/chat_bubble.dart';

class AiChatState {
  final List<ChatMessage> messages;
  final bool isConnected;
  final bool isConnecting;
  final bool isStreaming;
  final bool isListening;
  final String? errorMessage;
  final XFile? selectedImage;
  final int? currentConversationId;

  AiChatState({
    this.messages = const [],
    this.isConnected = false,
    this.isConnecting = true,
    this.isStreaming = false,
    this.isListening = false,
    this.errorMessage,
    this.selectedImage,
    this.currentConversationId,
  });

  AiChatState copyWith({
    List<ChatMessage>? messages,
    bool? isConnected,
    bool? isConnecting,
    bool? isStreaming,
    bool? isListening,
    String? errorMessage,
    XFile? selectedImage,
    int? currentConversationId,
    bool clearErrorMessage = false,
    bool clearSelectedImage = false,
  }) {
    return AiChatState(
      messages: messages ?? this.messages,
      isConnected: isConnected ?? this.isConnected,
      isConnecting: isConnecting ?? this.isConnecting,
      isStreaming: isStreaming ?? this.isStreaming,
      isListening: isListening ?? this.isListening,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      selectedImage: clearSelectedImage ? null : (selectedImage ?? this.selectedImage),
      currentConversationId: currentConversationId ?? this.currentConversationId,
    );
  }
}
