import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/data/models/recipe_models/recipe_model.dart' show RecipeModel;
import 'package:recipe_app/helpers/responsive/size_helper_extension.dart' show SizeHelperExtension;
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart' show ThemeHelperExtension;
import 'package:recipe_app/logic/recipe_cubit/recipe_cubit.dart';
import 'package:recipe_app/l10n/app_localizations.dart';

class RatingNotesSection extends StatelessWidget {
  final RecipeModel recipe;
  final ValueChanged<RecipeModel> onRecipeChanged;

  const RatingNotesSection({
    required this.recipe,
    required this.onRecipeChanged,
    super.key,
  });

  RecipeModel _cloneWith(RecipeModel r, {bool? isLiked, bool updateIsLiked = false, String? userNote, bool updateUserNote = false}) {
    return RecipeModel(
      id: r.id,
      title: r.title,
      timeMinutes: r.timeMinutes,
      price: r.price,
      link: r.link,
      tags: r.tags,
      ingredients: r.ingredients,
      image: r.image,
      description: r.description,
      calories: r.calories,
      isLiked: updateIsLiked ? isLiked : r.isLiked,
      userNote: updateUserNote ? userNote : r.userNote,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.all(context.setMineSize(16)),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest.withAlpha(50),
        borderRadius: BorderRadius.circular(context.setMineSize(16)),
        border: Border.all(
          color: context.colorScheme.primary.withAlpha(40),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.rateMealTitle,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colorScheme.primary,
            ),
          ),
          SizedBox(height: context.setMineSize(12)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _RatingButton(
                isActive: recipe.isLiked == true,
                icon: Icons.thumb_up_rounded,
                activeColor: Colors.green,
                label: l10n.likeLabel,
                onTap: () {
                  final newVal = recipe.isLiked == true ? null : true;
                  context.read<RecipeCubit>().updateRecipeRating(recipe.id, isLiked: newVal);
                  onRecipeChanged(_cloneWith(recipe, isLiked: newVal, updateIsLiked: true));
                },
              ),
              _RatingButton(
                isActive: recipe.isLiked == false,
                icon: Icons.thumb_down_rounded,
                activeColor: Colors.red,
                label: l10n.dislikeLabel,
                onTap: () {
                  final newVal = recipe.isLiked == false ? null : false;
                  context.read<RecipeCubit>().updateRecipeRating(recipe.id, isLiked: newVal);
                  onRecipeChanged(_cloneWith(recipe, isLiked: newVal, updateIsLiked: true));
                },
              ),
            ],
          ),
          SizedBox(height: context.setMineSize(16)),
          Text(
            l10n.myNotesLabel,
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: context.setMineSize(8)),
          _NotesInputSection(
            initialNote: recipe.userNote ?? '',
            onSave: (note) {
              context.read<RecipeCubit>().updateRecipeRating(recipe.id, userNote: note);
              onRecipeChanged(_cloneWith(recipe, userNote: note, updateUserNote: true));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.saveNotesSuccess)),
              );
            },
            saveText: l10n.saveNotes,
          ),
        ],
      ),
    );
  }
}

class _RatingButton extends StatelessWidget {
  final bool isActive;
  final IconData icon;
  final Color activeColor;
  final String label;
  final VoidCallback onTap;

  const _RatingButton({
    required this.isActive,
    required this.icon,
    required this.activeColor,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? activeColor.withAlpha(25) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? activeColor.withAlpha(100) : Colors.grey.withAlpha(50),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isActive ? activeColor : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isActive ? activeColor : Colors.grey,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotesInputSection extends StatefulWidget {
  final String initialNote;
  final ValueChanged<String> onSave;
  final String saveText;

  const _NotesInputSection({
    required this.initialNote,
    required this.onSave,
    required this.saveText,
  });

  @override
  State<_NotesInputSection> createState() => _NotesInputSectionState();
}

class _NotesInputSectionState extends State<_NotesInputSection> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialNote);
  }

  @override
  void didUpdateWidget(covariant _NotesInputSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialNote != widget.initialNote) {
      _controller.value = TextEditingValue(
        text: widget.initialNote,
        selection: TextSelection.collapsed(offset: widget.initialNote.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextField(
          controller: _controller,
          maxLines: 3,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurface,
          ),
          onTapOutside: (event) {
            FocusScope.of(context).unfocus();
          },
          decoration: InputDecoration(
            hintText: widget.saveText,
            hintStyle: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.outline,
            ),
            filled: true,
            fillColor: context.colorScheme.surfaceContainer,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.setMineSize(12)),
              borderSide: BorderSide(color: context.colorScheme.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.setMineSize(12)),
              borderSide: BorderSide(color: context.colorScheme.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.setMineSize(12)),
              borderSide: BorderSide(color: context.colorScheme.primary),
            ),
            contentPadding: EdgeInsets.all(context.setMineSize(12)),
            isDense: true,
          ),
        ),
        SizedBox(height: context.setMineSize(8)),
        TextButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            widget.onSave(_controller.text);
          },
          style: TextButton.styleFrom(
            foregroundColor: context.colorScheme.primary,
            textStyle: context.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          child: Text(widget.saveText),
        ),
      ],
    );
  }
}
