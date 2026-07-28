import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocConsumer, ReadContext;

import 'package:recipe_app/helpers/responsive/size_helper_extension.dart'
    show SizeHelperExtension;
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart'
    show ThemeHelperExtension;

import 'package:recipe_app/presentation/profile/widgets/log_out_button.dart'
    show LogOutButton;
import 'package:recipe_app/presentation/profile/widgets/page_header.dart'
    show PageHeader;
import 'package:recipe_app/presentation/profile/widgets/profile_card.dart'
    show ProfileCard;
import 'package:recipe_app/presentation/profile/widgets/profile_tile.dart'
    show CustomProfileTile;
import 'package:recipe_app/logic/user_cubit/user_cubit.dart';
import 'package:recipe_app/presentation/widgets/custom_dialog.dart'
    show CustomDialog;

import 'package:recipe_app/logic/locale_cubit/locale_cubit.dart';
import 'package:recipe_app/l10n/app_localizations.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().getMe();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocConsumer<UserCubit, UserState>(
      listener: (consumerContext, state) {
        if (state is GetMeFailure) {
          showDialog(
            context: context,
            builder: (context) => CustomDialog(
              icon: Icons.sentiment_dissatisfied_rounded,
              backgroundColor: context.colorScheme.errorContainer,
              text: state.errorMessage,
              textColor: context.colorScheme.onErrorContainer,
            ),
          );
        }
        if (state is UploadProfilePicSuccess) {
          context.read<UserCubit>().getMe();
        }
        if (state is UploadProfilePicFailure) {
          showDialog(
            context: context,
            builder: (context) => CustomDialog(
              icon: Icons.sentiment_dissatisfied_rounded,
              backgroundColor: context.colorScheme.errorContainer,
              text: state.errorMessage,
              textColor: context.colorScheme.onErrorContainer,
            ),
          );
        }
      },
      builder: (consumerContext, state) {
        return state is GetMeLoading || state is UploadProfilePicLoading
            ? SafeArea(
                child: Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                ),
              )
            : state is GetMeSuccess
            ? Scaffold(
                body: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        PageHeader(state.user.profilePic),
                        ProfileCard(
                          title: l10n.personal,
                          children: [
                            CustomProfileTile(
                              icon: Icons.alternate_email_rounded,
                              text: state.user.name,
                            ),
                            Divider(
                              color: context.colorScheme.surfaceContainerHigh,
                            ),
                            CustomProfileTile(
                              icon: Icons.mail_outline_rounded,
                              text: state.user.email,
                            ),
                          ],
                        ),
                        ProfileCard(
                          title: l10n.help,
                          children: [
                            CustomProfileTile(
                              icon: Icons.chat_bubble_outline_rounded,
                              text: l10n.reportBug,
                              sufix: Icons.chevron_right_rounded,
                              onSufixTap: () {
                                context.read<UserCubit>().sendEmail();
                              },
                            ),
                            Divider(
                              color: context.colorScheme.surfaceContainerHigh,
                            ),
                            CustomProfileTile(
                              icon: Icons.description_outlined,
                              text: l10n.termsOfUse,
                              sufix: Icons.chevron_right_rounded,
                              onSufixTap: () {
                                Navigator.pushNamed(context, "terms_of_use");
                              },
                            ),
                          ],
                        ),
                        ProfileCard(
                          title: l10n.account,
                          children: [
                            CustomProfileTile(
                              icon: Icons.edit_outlined,
                              text: l10n.editAccount,
                              sufix: Icons.chevron_right_rounded,
                              onSufixTap: () {
                                Navigator.pushNamed(context, "edit_profile");
                              },
                            ),
                            Divider(
                              color: context.colorScheme.surfaceContainerHigh,
                            ),
                            CustomProfileTile(
                              icon: Icons.language_outlined,
                              text: l10n.changeLanguage,
                              sufix: Icons.chevron_right_rounded,
                              onSufixTap: () {
                                context.read<LocaleCubit>().toggleLocale();
                              },
                            ),
                          ],
                        ),
                        LogOutButton(),
                        SizedBox(height: context.setMineSize(100)),
                      ],
                    ),
                  ),
                ),
              )
            : SizedBox(child: Text("Somthing happen"));
      },
    );
  }
}
