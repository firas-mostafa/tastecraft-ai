import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:recipe_app/helpers/responsive/size_helper_extension.dart';
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final String? imagePath;
  final String? audioPath;
  const ChatMessage({
    required this.text,
    required this.isUser,
    this.imagePath,
    this.audioPath,
  });
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isStreaming;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isStreaming,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = message.imagePath != null;
    final hasAudio = message.audioPath != null;
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          bottom: context.setMineSize(12),
          left: message.isUser ? context.setMineSize(50) : 0,
          right: message.isUser ? 0 : context.setMineSize(50),
        ),
        padding: EdgeInsets.all(context.setMineSize(12)),
        decoration: BoxDecoration(
          color: message.isUser
              ? context.colorScheme.primary
              : context.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(context.setMineSize(16)),
            topRight: Radius.circular(context.setMineSize(16)),
            bottomLeft: Radius.circular(
              message.isUser ? context.setMineSize(16) : 0,
            ),
            bottomRight: Radius.circular(
              message.isUser ? 0 : context.setMineSize(16),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: context.colorScheme.shadow.withAlpha(5),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasImage) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(context.setMineSize(12)),
                child: Image.file(
                  File(message.imagePath!),
                  width: context.setMineSize(200),
                  fit: BoxFit.cover,
                ),
              ),
              if (message.text.isNotEmpty)
                SizedBox(height: context.setMineSize(8)),
            ],
            if (hasAudio) ...[
              VoiceMessageBubble(
                audioPath: message.audioPath!,
                isUser: message.isUser,
              ),
            ],
            if (!hasAudio && (message.text.isNotEmpty || !message.isUser))
              message.text.isEmpty && isStreaming
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : MarkdownBody(
                      data: message.text,
                      selectable: true,
                      onTapLink: (text, href, title) async {
                        if (href != null) {
                          final uri = Uri.parse(href);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri,
                                mode: LaunchMode.externalApplication);
                          }
                        }
                      },
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(
                          color: message.isUser
                              ? context.colorScheme.onPrimary
                              : context.colorScheme.onSurface,
                          fontSize: context.setMineSize(14),
                        ),
                        strong: TextStyle(
                          color: message.isUser
                              ? context.colorScheme.onPrimary
                              : context.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        a: TextStyle(
                          color: message.isUser
                              ? context.colorScheme.onPrimaryContainer
                              : context.colorScheme.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
          ],
        ),
      ),
    );
  }
}

class VoiceMessageBubble extends StatefulWidget {
  final String audioPath;
  final bool isUser;

  const VoiceMessageBubble({
    super.key,
    required this.audioPath,
    required this.isUser,
  });

  @override
  State<VoiceMessageBubble> createState() => _VoiceMessageBubbleState();
}

class _VoiceMessageBubbleState extends State<VoiceMessageBubble> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  void _initAudio() {
    _audioPlayer.onDurationChanged.listen((d) {
      if (mounted) setState(() => _duration = d);
    });
    _audioPlayer.onPositionChanged.listen((p) {
      if (mounted) setState(() => _position = p);
    });
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlay() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(DeviceFileSource(widget.audioPath));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = widget.isUser ? colorScheme.onPrimary : colorScheme.primary;

    return Container(
      constraints: const BoxConstraints(maxWidth: 200),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
              size: 32,
              color: primaryColor,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: _togglePlay,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 2,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 8),
                    activeTrackColor: primaryColor,
                    inactiveTrackColor: primaryColor.withAlpha(50),
                    thumbColor: primaryColor,
                    overlayColor: primaryColor.withAlpha(20),
                    valueIndicatorColor: primaryColor,
                  ),
                  child: Slider(
                    min: 0,
                    max: _duration.inMilliseconds.toDouble(),
                    value: _position.inMilliseconds.toDouble().clamp(0.0, _duration.inMilliseconds.toDouble()),
                    onChanged: (value) {
                      _audioPlayer.seek(Duration(milliseconds: value.toInt()));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    _formatDuration(_position) + " / " + _formatDuration(_duration),
                    style: TextStyle(
                      color: primaryColor.withAlpha(200),
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}
