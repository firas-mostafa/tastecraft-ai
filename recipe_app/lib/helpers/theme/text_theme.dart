import 'package:flutter/material.dart' show TextTheme, BuildContext;
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:recipe_app/helpers/responsive/size_helper_extension.dart'
    show SizeHelperExtension;
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart'
    show ThemeHelperExtension;

TextTheme createTextTheme(
  BuildContext context,
  String bodyFontString,
  String displayFontString,
) {
  TextTheme baseTextTheme = context.textTheme;
  TextTheme bodyTextTheme = GoogleFonts.getTextTheme(
    bodyFontString,
    baseTextTheme,
  );
  TextTheme displayTextTheme = GoogleFonts.getTextTheme(
    displayFontString,

    baseTextTheme,
  );
  TextTheme textTheme = displayTextTheme.copyWith(
    displayLarge: displayTextTheme.displayLarge!.copyWith(
      fontSize: context.setMineSize(57),
    ),
    displayMedium: displayTextTheme.displayMedium!.copyWith(
      fontSize: context.setMineSize(45),
    ),
    displaySmall: displayTextTheme.displaySmall!.copyWith(
      fontSize: context.setMineSize(36),
    ),
    headlineLarge: displayTextTheme.headlineLarge!.copyWith(
      fontSize: context.setMineSize(32),
    ),
    headlineMedium: displayTextTheme.headlineMedium!.copyWith(
      fontSize: context.setMineSize(28),
    ),
    headlineSmall: displayTextTheme.headlineSmall!.copyWith(
      fontSize: context.setMineSize(24),
    ),
    titleLarge: displayTextTheme.titleLarge!.copyWith(
      fontSize: context.setMineSize(22),
    ),
    titleMedium: displayTextTheme.titleMedium!.copyWith(
      fontSize: context.setMineSize(16),
    ),
    titleSmall: displayTextTheme.titleSmall!.copyWith(
      fontSize: context.setMineSize(14),
    ),
    bodyLarge: bodyTextTheme.bodyLarge!.copyWith(
      fontSize: context.setMineSize(16),
    ),
    bodyMedium: bodyTextTheme.bodyMedium!.copyWith(
      fontSize: context.setMineSize(14),
    ),
    bodySmall: bodyTextTheme.bodySmall!.copyWith(
      fontSize: context.setMineSize(12),
    ),
    labelLarge: bodyTextTheme.labelLarge!.copyWith(
      fontSize: context.setMineSize(14),
    ),
    labelMedium: bodyTextTheme.labelMedium!.copyWith(
      fontSize: context.setMineSize(12),
    ),
    labelSmall: bodyTextTheme.labelSmall!.copyWith(
      fontSize: context.setMineSize(10),
    ),
  );
  return textTheme;
}
