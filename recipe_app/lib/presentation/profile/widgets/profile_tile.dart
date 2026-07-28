import 'package:flutter/material.dart';
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart'
    show ThemeHelperExtension;

class CustomProfileTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onSufixTap;
  final IconData? sufix;
  const CustomProfileTile({
    super.key,
    required this.icon,
    required this.text,
    this.sufix,
    this.onSufixTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: ListTile(
            leading: Icon(icon, color: context.colorScheme.primary),
            title: Text(
              text,
              style: context.textTheme.bodyMedium!.copyWith(
                color: context.colorScheme.tertiary,
              ),
            ),
          ),
        ),
        sufix != null
            ? IconButton(
                onPressed: onSufixTap ?? () {},
                icon: Icon(sufix!, color: context.colorScheme.secondary),
              )
            : SizedBox(),
      ],
    );
  }
}
