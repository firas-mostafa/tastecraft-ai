import 'package:flutter/material.dart';
import 'package:recipe_app/helpers/responsive/size_helper_extension.dart'
    show SizeHelperExtension;
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart'
    show ThemeHelperExtension;
import 'package:recipe_app/presentation/widgets/translated_text.dart';

import 'package:recipe_app/helpers/image/recipe_image_helper.dart';

class RecipeHeroAppBar extends StatelessWidget {
  final int id;
  final String title;
  final String? image;

  const RecipeHeroAppBar({
    required this.id,
    required this.title,
    required this.image,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = image != null && image!.isNotEmpty;
    final displayImage = hasImage
        ? image!
        : RecipeImageHelper.getFallbackImage(id, title);

    return SliverAppBar(
      expandedHeight: context.setHeight(350),
      pinned: true,
      stretch: true,
      backgroundColor: context.colorScheme.primary,
      leading: Padding(
        padding: EdgeInsets.all(context.setMineSize(4)),
        child: CircleAvatar(
          backgroundColor: context.colorScheme.surface.withAlpha(200),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: context.setMineSize(18),
              color: context.colorScheme.onSurface,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              displayImage,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      context.colorScheme.primary,
                      context.colorScheme.tertiary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.restaurant_menu_rounded,
                    size: context.setMineSize(80),
                    color: Colors.white.withAlpha(100),
                  ),
                ),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withAlpha(160)],
                  stops: const [0.5, 1.0],
                ),
              ),
            ),
          ],
        ),
        title: TranslatedText(
          title,
          style: context.textTheme.titleLarge!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        titlePadding: EdgeInsets.only(
          left: context.setMineSize(16),
          bottom: context.setMineSize(16),
          right: context.setMineSize(48),
        ),
      ),
    );
  }
}
