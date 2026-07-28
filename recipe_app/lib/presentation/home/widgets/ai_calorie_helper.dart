import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:recipe_app/helpers/responsive/size_helper_extension.dart';
import 'package:recipe_app/presentation/home/logic/ai_calorie_cubit/ai_calorie_state.dart';
import 'package:recipe_app/l10n/app_localizations.dart';

void handleAiCalorieState(BuildContext context, AiCalorieState state) {
  final l10n = AppLocalizations.of(context)!;
  if (state is AiCalorieLoading) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            SizedBox(width: context.setMineSize(16)),
            Text(l10n.aiCalorieLoading),
          ],
        ),
      ),
    );
  } else if (state is AiCalorieSuccess) {
    Navigator.pop(context); // Close loading dialog
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.aiCalorieResult),
        content: SingleChildScrollView(
          child: MarkdownBody(data: state.result),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  } else if (state is AiCalorieFailure) {
    Navigator.pop(context); // Close loading dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(state.errorMessage)),
    );
  }
}
