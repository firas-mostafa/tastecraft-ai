import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recipe_app/core/api/end_ponits.dart';
import 'package:recipe_app/helpers/cache/cache_helper.dart';
import 'package:recipe_app/presentation/ai_chat/logic/chat_history_cubit/chat_history_cubit.dart';
import 'package:recipe_app/presentation/ai_chat/logic/chat_history_cubit/chat_history_state.dart';
import 'package:recipe_app/presentation/ai_chat/widgets/chat_bubble.dart';
import 'ai_chat_state.dart';

class AiChatCubit extends Cubit<AiChatState> {
  final ChatHistoryCubit chatHistoryCubit;
  
  WebSocket? _webSocket;
  final AudioRecorder _audioRecorder = AudioRecorder();
  final ImagePicker _picker = ImagePicker();

  AiChatCubit(this.chatHistoryCubit) : super(AiChatState()) {
    connectWebSocket();
  }

  Future<void> startListening(Function(String) onError) async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      onError('Microphone permission denied');
      return;
    }

    try {
      if (await _audioRecorder.hasPermission()) {
        final dir = await getTemporaryDirectory();
        final path = '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
        
        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc), 
          path: path,
        );
        emit(state.copyWith(isListening: true));
      } else {
        onError('Microphone permission denied');
      }
    } catch (e) {
      onError('Failed to start recording: $e');
    }
  }

  Future<void> stopListening(Function(String) onError) async {
    try {
      final String? path = await _audioRecorder.stop();
      emit(state.copyWith(isListening: false));
      if (path != null) {
        await sendAudioMessage(path);
      }
    } catch (e) {
      onError('Failed to stop recording: $e');
    }
  }

  Future<void> sendAudioMessage(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) return;

    final messages = List<ChatMessage>.from(state.messages);
    messages.add(ChatMessage(
      text: '',
      isUser: true,
      audioPath: filePath,
    ));

    emit(state.copyWith(messages: messages));

    try {
      final bytes = await file.readAsBytes();
      final base64Audio = base64Encode(bytes);

      final Map<String, dynamic> payload = {
        'prompt': 'Audio Message',
        'audio': base64Audio,
      };

      if (_webSocket != null && state.isConnected) {
        _webSocket!.add(jsonEncode(payload));
      } else {
        emit(state.copyWith(errorMessage: 'Connection lost. Reconnecting...'));
        connectWebSocket().then((_) {
          if (state.isConnected && _webSocket != null) {
            _webSocket!.add(jsonEncode(payload));
          }
        });
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to process audio: $e'));
    }
  }


  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 70,
      );
      if (image != null) {
        emit(state.copyWith(selectedImage: image));
      }
    } catch (e) {
      // Error picking image
    }
  }

  void removeSelectedImage() {
    emit(state.copyWith(clearSelectedImage: true));
  }

  String _getWebSocketUrl(String? token) {
    String httpUrl = EndPoint.baseUrl;
    String wsUrl = httpUrl
        .replaceAll('http://', 'ws://')
        .replaceAll('https://', 'wss://');
    if (wsUrl.endsWith('/')) {
      wsUrl = wsUrl.substring(0, wsUrl.length - 1);
    }
    wsUrl = '$wsUrl/ws/chat/';
    if (token != null) {
      wsUrl = '$wsUrl?token=$token';
      if (state.currentConversationId != null) {
        wsUrl = '$wsUrl&conversation_id=${state.currentConversationId}';
      }
    }
    return wsUrl;
  }

  Future<void> connectWebSocket() async {
    emit(state.copyWith(isConnecting: true, isConnected: false, clearErrorMessage: true));

    try {
      final String? token = CacheHelper().getDataString(ApiKey.token);
      final String wsUrl = _getWebSocketUrl(token);

      _webSocket = await WebSocket.connect(
        wsUrl,
        headers: token != null ? {'Authorization': 'Token $token'} : null,
      ).timeout(const Duration(seconds: 10));

      emit(state.copyWith(isConnected: true, isConnecting: false));

      _webSocket!.listen(
        (message) {
          _handleWebSocketMessage(message);
        },
        onError: (error) {
          _handleWebSocketError(error.toString());
        },
        onDone: () {
          _handleWebSocketDone();
        },
      );
    } catch (e) {
      _handleWebSocketError(e.toString());
    }
  }

  void _handleWebSocketMessage(dynamic message) {
    try {
      final Map<String, dynamic> data = jsonDecode(message as String);
      final String type = data['type'] ?? '';

      if (type == 'status') {
        // Connected status from backend
      } else if (type == 'start') {
        final messages = List<ChatMessage>.from(state.messages);
        messages.add(const ChatMessage(text: '', isUser: false));
        emit(state.copyWith(isStreaming: true, messages: messages));
      } else if (type == 'chunk') {
        final String text = data['text'] ?? '';
        final messages = List<ChatMessage>.from(state.messages);
        if (messages.isNotEmpty && !messages.last.isUser) {
          messages[messages.length - 1] = ChatMessage(
            text: messages.last.text + text,
            isUser: false,
          );
        }
        emit(state.copyWith(messages: messages));
      } else if (type == 'done') {
        final String fullText = data['full_text'] ?? '';
        final int? convId = data['conversation_id'];
        
        final messages = List<ChatMessage>.from(state.messages);
        if (messages.isNotEmpty && !messages.last.isUser) {
          messages[messages.length - 1] = ChatMessage(
            text: fullText,
            isUser: false,
          );
        }
        
        emit(state.copyWith(
          isStreaming: false,
          messages: messages,
          currentConversationId: convId ?? state.currentConversationId,
        ));
      } else if (type == 'error') {
        final String errorMsg = data['message'] ?? 'An error occurred';
        
        final messages = List<ChatMessage>.from(state.messages);
        if (messages.isNotEmpty && !messages.last.isUser && messages.last.text.isEmpty) {
           messages[messages.length - 1] = ChatMessage(
             text: '⚠️ $errorMsg',
             isUser: false,
           );
        }
        
        emit(state.copyWith(
          isStreaming: false,
          errorMessage: errorMsg,
          messages: messages,
        ));
      }
    } catch (e) {
      // Decode or handling error
    }
  }

  void _handleWebSocketError(String error) {
    emit(state.copyWith(
      isConnected: false,
      isConnecting: false,
      errorMessage: 'Failed to connect: $error',
    ));
  }

  void _handleWebSocketDone() {
    emit(state.copyWith(
      isConnected: false,
      isConnecting: false,
    ));
  }

  Future<void> sendMessage(String text, {Function(String, XFile?)? onRestoreInput}) async {
    final XFile? imageToSend = state.selectedImage;
    if (text.isEmpty && imageToSend == null) return;

    final messages = List<ChatMessage>.from(state.messages);
    messages.add(ChatMessage(
      text: text,
      isUser: true,
      imagePath: imageToSend?.path,
    ));

    emit(state.copyWith(
      clearSelectedImage: true,
      messages: messages,
    ));

    final Map<String, dynamic> payload = {'prompt': text};

    if (imageToSend != null) {
      try {
        final bytes = await imageToSend.readAsBytes();
        final base64Image = base64Encode(bytes);
        payload['image'] = base64Image;
      } catch (e) {
        emit(state.copyWith(errorMessage: 'Failed to process image: $e'));
        if (onRestoreInput != null) onRestoreInput(text, imageToSend);
        return;
      }
    }

    if (_webSocket != null && state.isConnected) {
      _webSocket!.add(jsonEncode(payload));
    } else {
      emit(state.copyWith(errorMessage: 'Connection lost. Reconnecting...'));
      connectWebSocket().then((_) {
        if (state.isConnected && _webSocket != null) {
          _webSocket!.add(jsonEncode(payload));
        } else {
           if (onRestoreInput != null) onRestoreInput(text, imageToSend);
        }
      });
    }
  }

  Future<void> loadOldConversation(int id, Function(String) onError) async {
    _webSocket?.close();
    emit(state.copyWith(
      messages: [],
      isConnecting: true,
      currentConversationId: id,
    ));
    
    await chatHistoryCubit.fetchConversationDetail(id);
    final historyState = chatHistoryCubit.state;
    
    if (historyState is ChatHistoryDetailLoaded) {
      final oldMessages = historyState.conversation.messages.map((msg) => ChatMessage(
        text: msg.content,
        isUser: msg.role == 'human',
      )).toList();
      
      emit(state.copyWith(messages: oldMessages));
      connectWebSocket();
    } else if (historyState is ChatHistoryDetailError) {
      onError('Failed to load conversation: ${historyState.message}');
      emit(state.copyWith(isConnecting: false));
    }
  }

  @override
  Future<void> close() {
    _webSocket?.close();
    return super.close();
  }
}
