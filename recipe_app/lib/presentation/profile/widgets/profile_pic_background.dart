import 'package:flutter/material.dart';
import 'package:recipe_app/helpers/responsive/size_helper_extension.dart'
    show SizeHelperExtension;
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart'
    show ThemeHelperExtension;

class ProfilePicBackground extends StatelessWidget {
  const ProfilePicBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.setHeight(175),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.colorScheme.secondary,
            context.colorScheme.primary,
            context.colorScheme.tertiary,
          ],
        ),
      ),
    );
  }
}
