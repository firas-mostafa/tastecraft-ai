import 'package:flutter/material.dart';
import '/helpers/image/image_helper.dart' show ImageHelper;
import '/helpers/responsive/device_utils.dart' show DeviceUtils;
import '/helpers/responsive/size_helper_extension.dart'
    show SizeHelperExtension;
import '/helpers/theme/theme_helper_extension.dart' show ThemeHelperExtension;
import 'profile_pic_background.dart' show ProfilePicBackground;
import 'profile_picture.dart' show ProfilePicture;
import 'package:recipe_app/presentation/widgets/theme_switcher.dart'
    show ThemeSwitcher;

class PageHeader extends StatelessWidget {
  final String? profilePic;
  const PageHeader(this.profilePic, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: DeviceUtils.valueDecider(
        context,
        onMobile: context.screenWidth,
        onDesktop: context.setWidth(300),
      ),
      height: context.setHeight(300),
      child: Stack(
        children: [
          ProfilePicBackground(),
          Align(
            alignment: Alignment(-0.9, 0.5),
            child: ProfilePicture(
              child: profilePic != null && profilePic!.isNotEmpty
                  ? Image.network(profilePic!, fit: BoxFit.cover)
                  : Image.asset(ImageHelper.profilePic),
            ),
          ),
          Align(
            alignment: Alignment(.9, -.65),
            child: ThemeSwitcher(color: context.colorScheme.onPrimary),
          ),
        ],
      ),
    );
  }
}
