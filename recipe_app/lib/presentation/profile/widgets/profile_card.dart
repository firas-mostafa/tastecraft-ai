import 'package:flutter/material.dart';
import 'package:recipe_app/helpers/responsive/device_utils.dart'
    show DeviceUtils;
import 'package:recipe_app/helpers/responsive/size_helper_extension.dart'
    show SizeHelperExtension;
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart'
    show ThemeHelperExtension;

class ProfileCard extends StatelessWidget {
  final List<Widget> children;
  final String title;
  const ProfileCard({super.key, required this.children, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.setMineSize(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.textTheme.bodySmall!.copyWith(
              color: context.colorScheme.primary,
            ),
          ),
          SizedBox(height: context.setHeight(10)),
          Container(
            padding: EdgeInsets.all(context.setMineSize(10)),
            width: context.setWidth(
              DeviceUtils.valueDecider(
                context,
                onMobile: 450,
                onTablet: 460,
                onDesktop: 300,
              ),
            ),

            decoration: BoxDecoration(
              color: context.colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(context.setMineSize(25)),
              boxShadow: [
                BoxShadow(
                  color: context.colorScheme.shadow.withAlpha(30),
                  blurRadius: 30,
                  offset: Offset(2, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: children,
            ),
          ),
        ],
      ),
    );
  }
}
