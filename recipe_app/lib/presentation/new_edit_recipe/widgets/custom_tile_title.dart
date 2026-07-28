import 'package:flutter/widgets.dart';
import 'package:recipe_app/helpers/responsive/size_helper_extension.dart'
    show SizeHelperExtension;
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart'
    show ThemeHelperExtension;

class CustomTileTitle extends StatelessWidget {
  final String title;
  const CustomTileTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: context.setHeight(10)),
        Text(
          title,
          style: context.textTheme.bodySmall!.copyWith(
            color: context.colorScheme.primary,
          ),
        ),
        SizedBox(height: context.setHeight(5)),
      ],
    );
  }
}
