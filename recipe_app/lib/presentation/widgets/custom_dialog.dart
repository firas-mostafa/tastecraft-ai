import 'package:flutter/material.dart';
import 'package:recipe_app/helpers/responsive/size_helper_extension.dart'
    show SizeHelperExtension;
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart'
    show ThemeHelperExtension;

class CustomDialog extends StatelessWidget {
  final Color backgroundColor;

  final Color textColor;

  final String text;
  final IconData icon;

  const CustomDialog({
    super.key,
    required this.backgroundColor,
    required this.textColor,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shadowColor: context.colorScheme.shadow.withAlpha(190),
      insetPadding: EdgeInsets.all(context.setMineSize(30)),

      backgroundColor: backgroundColor,
      child: SizedBox(
        width: context.setMineSize(400),
        height: context.setHeight(400),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.setWidth(10)),
          child: Center(
            child: SizedBox(
              height: context.setHeight(300),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    icon,
                    color: textColor,
                    size: context.setMineSize(100),
                  ),
                  Text(
                    text,
                    style: context.textTheme.labelMedium!.copyWith(
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
