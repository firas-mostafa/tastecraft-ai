import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart'
    show ThemeHelperExtension;
import 'package:recipe_app/helpers/responsive/size_helper_extension.dart'
    show SizeHelperExtension;
import 'package:recipe_app/helpers/image/image_helper.dart' show ImageHelper;
import 'package:recipe_app/logic/user_cubit/user_cubit.dart';
import 'package:recipe_app/l10n/app_localizations.dart';

class HeaderTitleWidget extends StatelessWidget {
  const HeaderTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.restaurant_menu_rounded,
              color: context.colorScheme.onPrimary,
              size: context.setMineSize(24),
            ),
            SizedBox(width: context.setMineSize(8)),
            Text(
              l10n.appTitle,
              style: context.textTheme.titleLarge!.copyWith(
                color: context.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(width: context.setMineSize(12)),
            BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                final String? profilePic = state is GetMeSuccess
                    ? state.user.profilePic
                    : null;
                return SizedBox(
                  width: context.setMineSize(32),
                  height: context.setMineSize(32),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      context.setMineSize(16),
                    ),
                    child: profilePic != null && profilePic.isNotEmpty
                        ? Image.network(profilePic, fit: BoxFit.cover)
                        : Image.asset(ImageHelper.profilePic),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
