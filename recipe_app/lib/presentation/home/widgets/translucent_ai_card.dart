import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart'
    show ThemeHelperExtension;
import 'package:recipe_app/helpers/responsive/size_helper_extension.dart'
    show SizeHelperExtension;
import 'package:recipe_app/logic/recipe_cubit/recipe_cubit.dart';
import 'package:recipe_app/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_app/presentation/home/logic/ai_calorie_cubit/ai_calorie_cubit.dart';

class TranslucentAiCard extends StatelessWidget {
  const TranslucentAiCard({super.key});

  void _showImageSourceBottomSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.setMineSize(20)),
        ),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_rounded),
                title: Text(l10n.aiChatPhotoGallery),
                onTap: () async {
                  Navigator.pop(bottomSheetContext);
                  final picker = ImagePicker();
                  final image = await picker.pickImage(source: ImageSource.gallery);
                  if (image != null && context.mounted) {
                    final languageCode = Localizations.localeOf(context).languageCode;
                    context.read<AiCalorieCubit>().analyzeCalories(image, languageCode);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_rounded),
                title: Text(l10n.aiChatCamera),
                onTap: () async {
                  Navigator.pop(bottomSheetContext);
                  final picker = ImagePicker();
                  final image = await picker.pickImage(source: ImageSource.camera);
                  if (image != null && context.mounted) {
                    final languageCode = Localizations.localeOf(context).languageCode;
                    context.read<AiCalorieCubit>().analyzeCalories(image, languageCode);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'ai_chat').then((_) {
              if (context.mounted) context.read<RecipeCubit>().getRecipesList();
            }),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.setMineSize(10),
                vertical: context.setMineSize(10),
              ),
              decoration: BoxDecoration(
                color: context.colorScheme.onPrimary.withAlpha(40),
                borderRadius: BorderRadius.circular(context.setMineSize(16)),
                border: Border.all(color: context.colorScheme.onPrimary.withAlpha(65), width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: context.setMineSize(32),
                    height: context.setMineSize(32),
                    decoration: BoxDecoration(
                      color: context.colorScheme.onPrimary.withAlpha(50),
                      borderRadius: BorderRadius.circular(context.setMineSize(10)),
                    ),
                    child: Icon(
                      Icons.auto_awesome,
                      color: context.colorScheme.onPrimary,
                      size: context.setMineSize(16),
                    ),
                  ),
                  SizedBox(width: context.setMineSize(8)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.aiChefAssistant,
                          style: context.textTheme.titleSmall!.copyWith(
                            color: context.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: context.setMineSize(12),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: context.setMineSize(2)),
                        Text(
                          l10n.aiChefDescription,
                          style: context.textTheme.bodySmall!.copyWith(
                            color: context.colorScheme.onPrimary.withAlpha(200),
                            fontSize: context.setMineSize(10),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: context.setMineSize(10)),
        Expanded(
          child: GestureDetector(
            onTap: () => _showImageSourceBottomSheet(context),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.setMineSize(10),
                vertical: context.setMineSize(10),
              ),
              decoration: BoxDecoration(
                color: context.colorScheme.onPrimary.withAlpha(40),
                borderRadius: BorderRadius.circular(context.setMineSize(16)),
                border: Border.all(color: context.colorScheme.onPrimary.withAlpha(65), width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: context.setMineSize(32),
                    height: context.setMineSize(32),
                    decoration: BoxDecoration(
                      color: context.colorScheme.onPrimary.withAlpha(50),
                      borderRadius: BorderRadius.circular(context.setMineSize(10)),
                    ),
                    child: Icon(
                      Icons.calculate_rounded,
                      color: context.colorScheme.onPrimary,
                      size: context.setMineSize(16),
                    ),
                  ),
                  SizedBox(width: context.setMineSize(8)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.aiCalorieTitle,
                          style: context.textTheme.titleSmall!.copyWith(
                            color: context.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: context.setMineSize(12),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: context.setMineSize(2)),
                        Text(
                          l10n.aiCalorieCalculator,
                          style: context.textTheme.bodySmall!.copyWith(
                            color: context.colorScheme.onPrimary.withAlpha(200),
                            fontSize: context.setMineSize(10),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
