import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;
import 'package:image_picker/image_picker.dart' show ImagePicker, ImageSource;
import 'package:recipe_app/helpers/responsive/size_helper_extension.dart'
    show SizeHelperExtension;
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart'
    show ThemeHelperExtension;

import 'package:recipe_app/logic/user_cubit/user_cubit.dart' show UserCubit;

class ProfilePicture extends StatelessWidget {
  final Widget child;

  const ProfilePicture({super.key, required this.child});
  void _openImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(context.setWidth(10)),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4,
              child: child,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.setMineSize(200),
      height: context.setMineSize(200),
      child: Stack(
        children: [
          SizedBox(
            width: context.setMineSize(200),
            height: context.setMineSize(200),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(context.setMineSize(100)),
              child: GestureDetector(
                onTap: () {
                  _openImageDialog(context);
                },
                child: child,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(context.setMineSize(50)),
                color: context.colorScheme.surfaceContainer,
              ),
              child: IconButton(
                onPressed: () {
                  ImagePicker()
                      .pickImage(source: ImageSource.gallery)
                      .then(
                        (value) {
                          if (context.mounted && value != null) {
                            context.read<UserCubit>().uploadProfilePic(value);
                          }
                        },
                      );
                },
                icon: Icon(
                  Icons.edit_rounded,
                  color: context.colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
