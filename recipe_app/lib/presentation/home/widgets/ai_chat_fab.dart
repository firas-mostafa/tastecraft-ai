import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/helpers/responsive/size_helper_extension.dart';
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart';
import 'package:recipe_app/logic/recipe_cubit/recipe_cubit.dart';

class AiChatFab extends StatelessWidget {
  final bool show;
  const AiChatFab({super.key, required this.show});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.setHeight(80)),
      child: AnimatedScale(
        scale: show ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutBack,
        child: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, 'ai_chat').then((_) {
            if (context.mounted) context.read<RecipeCubit>().getRecipesList();
          }),
          elevation: 0,
          highlightElevation: 0,
          backgroundColor: Colors.transparent,
          shape: const CircleBorder(),
          clipBehavior: Clip.none,
          child: Container(
            width: context.setMineSize(56),
            height: context.setMineSize(56),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  context.colorScheme.primary,
                  context.colorScheme.tertiary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: context.colorScheme.primary.withAlpha(100),
                  blurRadius: 16,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.auto_awesome,
                color: context.colorScheme.onPrimary,
                size: context.setMineSize(24),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
