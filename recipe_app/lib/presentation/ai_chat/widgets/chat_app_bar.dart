import 'package:flutter/material.dart';
import 'package:recipe_app/helpers/responsive/size_helper_extension.dart';
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart';
import 'package:recipe_app/l10n/app_localizations.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isConnected;
  final bool isConnecting;
  final VoidCallback onHistoryPressed;

  const ChatAppBar({
    super.key,
    required this.isConnected,
    required this.isConnecting,
    required this.onHistoryPressed,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppBar(
      titleSpacing: 0,
      title: Row(
        children: [
          Container(
            padding: EdgeInsets.all(context.setMineSize(6)),
            decoration: BoxDecoration(
              color: context.colorScheme.primary.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.auto_awesome,
              color: context.colorScheme.primary,
              size: context.setMineSize(20),
            ),
          ),
          SizedBox(width: context.setMineSize(10)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.aiChefAssistant,
                style: context.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: context.setMineSize(6),
                    height: context.setMineSize(6),
                    decoration: BoxDecoration(
                      color: isConnected
                          ? Colors.green
                          : isConnecting
                              ? Colors.orange
                              : Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: context.setMineSize(4)),
                  Text(
                    isConnected
                        ? l10n.aiChatOnline
                        : isConnecting
                            ? l10n.aiChatConnecting
                            : l10n.aiChatOffline,
                    style: context.textTheme.bodySmall!.copyWith(
                      color: context.colorScheme.outline,
                      fontSize: context.setMineSize(10),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      backgroundColor: context.colorScheme.surface,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: context.colorScheme.secondary,
          size: context.setMineSize(20),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.history_rounded,
            color: context.colorScheme.primary,
          ),
          onPressed: onHistoryPressed,
          tooltip: 'Chat History',
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
