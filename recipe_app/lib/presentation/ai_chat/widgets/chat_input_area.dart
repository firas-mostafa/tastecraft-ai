import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_app/helpers/responsive/size_helper_extension.dart';
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart';
import 'package:recipe_app/l10n/app_localizations.dart';

class ChatInputArea extends StatelessWidget {
  final TextEditingController textController;
  final XFile? selectedImage;
  final bool isStreaming;
  final bool isListening;
  final VoidCallback onShowImageSource;
  final VoidCallback onRemoveImage;
  final VoidCallback onSendMessage;
  final VoidCallback onStartListening;
  final VoidCallback onStopListening;
  final Function(String) onChanged;

  const ChatInputArea({
    super.key,
    required this.textController,
    required this.selectedImage,
    required this.isStreaming,
    required this.isListening,
    required this.onShowImageSource,
    required this.onRemoveImage,
    required this.onSendMessage,
    required this.onStartListening,
    required this.onStopListening,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (selectedImage != null)
          Container(
            padding: EdgeInsets.all(context.setMineSize(8)),
            color: context.colorScheme.surfaceContainerLow,
            child: Row(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(context.setMineSize(8)),
                      child: Image.file(
                        File(selectedImage!.path),
                        width: context.setMineSize(60),
                        height: context.setMineSize(60),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 2,
                      right: 2,
                      child: GestureDetector(
                        onTap: onRemoveImage,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: context.setMineSize(12)),
                Text(
                  'Image selected. Ask a question about it!',
                  style: TextStyle(
                    fontSize: context.setMineSize(12),
                    color: context.colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.setMineSize(16),
            vertical: context.setMineSize(12),
          ),
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: context.colorScheme.outlineVariant,
                width: 0.5,
              ),
            ),
          ),
          child: SafeArea(
            child: Row(
              children: [
                IconButton(
                  onPressed: onShowImageSource,
                  icon: Icon(
                    Icons.add_photo_alternate_rounded,
                    color: context.colorScheme.primary,
                    size: context.setMineSize(26),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(
                        context.setMineSize(24),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: context.setMineSize(16)),
                        Expanded(
                          child: TextField(
                            controller: textController,
                            onChanged: onChanged,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              hintText: l10n.aiChatInputHint,
                              border: InputBorder.none,
                            ),
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => onSendMessage(),
                          ),
                        ),
                        if (isStreaming)
                          Container(
                            width: context.setMineSize(24),
                            height: context.setMineSize(24),
                            margin: EdgeInsets.only(
                              right: context.setMineSize(12),
                            ),
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: context.setMineSize(8)),
                IconButton(
                  onPressed: isStreaming
                      ? null
                      : isListening
                          ? onStopListening
                          : (textController.text.isEmpty &&
                                  selectedImage == null)
                              ? onStartListening
                              : onSendMessage,
                  icon: Container(
                    padding: EdgeInsets.all(context.setMineSize(10)),
                    decoration: BoxDecoration(
                      color: isStreaming
                          ? context.colorScheme.outlineVariant
                          : isListening
                              ? context.colorScheme.error
                              : context.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isListening
                          ? Icons.stop_rounded
                          : (textController.text.isEmpty &&
                                  selectedImage == null)
                              ? Icons.mic_none_rounded
                              : Icons.send_rounded,
                      color: context.colorScheme.onPrimary,
                      size: context.setMineSize(18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
