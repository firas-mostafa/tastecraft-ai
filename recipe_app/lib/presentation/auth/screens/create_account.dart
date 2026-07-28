import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/helpers/responsive/size_helper_extension.dart'
    show SizeHelperExtension;
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart'
    show ThemeHelperExtension;
import 'package:recipe_app/logic/user_cubit/user_cubit.dart';
import 'package:recipe_app/presentation/Auth/widget/auth_base.dart'
    show AuthBase;
import 'package:recipe_app/presentation/widgets/custom_text_button.dart'
    show CustomTextButton;
import 'package:recipe_app/presentation/widgets/custom_button.dart'
    show CustomButton;
import 'package:recipe_app/presentation/widgets/custom_text_field.dart'
    show CustomTextField;

import '../../widgets/custom_dialog.dart' show CustomDialog;
import '../logic/obscure/obscure_cubit.dart' show ObscureCubit;
import 'package:recipe_app/l10n/app_localizations.dart';

class CreateAccount extends StatelessWidget {
  const CreateAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listener: (consumerContext, state) {
        if (state is SignUpSuccess) {
          Navigator.pushReplacementNamed(context, '');
          showDialog(
            context: context,
            builder: (context) => CustomDialog(
              icon: Icons.mood_rounded,
              backgroundColor: context.colorScheme.primaryContainer,
              text: "Create Account Success",
              textColor: context.colorScheme.onPrimaryContainer,
            ),
          );
        } else if (state is SignUpFailure) {
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
        final l10n = AppLocalizations.of(context)!;
        return SafeArea(
          child: Scaffold(
            body: AuthBase(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.createAccountTitle,
                    style: context.textTheme.headlineLarge!.copyWith(
                      color: context.colorScheme.tertiary,
                    ),
                  ),
                  SizedBox(height: context.setHeight(20)),
                  CustomTextField(
                    controller: consumerContext.read<UserCubit>().signUpName,
                    textInputAction: TextInputAction.next,
                    focusNode: consumerContext
                        .read<UserCubit>()
                        .signUpNameFocuseNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(
                        consumerContext.read<UserCubit>().signUpEmailFocuseNode,
                      );
                    },
                    text: l10n.name,
                  ),
                  SizedBox(height: context.setHeight(20)),
                  CustomTextField(
                    controller: consumerContext.read<UserCubit>().signUpEmail,
                    text: l10n.email,
                    textInputAction: TextInputAction.next,
                    focusNode: consumerContext
                        .read<UserCubit>()
                        .signUpEmailFocuseNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(
                        consumerContext
                            .read<UserCubit>()
                            .signUpPasswordFocuseNode,
                      );
                    },
                  ),
                  SizedBox(height: context.setHeight(20)),
                  BlocProvider<ObscureCubit>(
                    create: (context) => ObscureCubit(),
                    child: Builder(
                      builder: (obscureContext) {
                        bool obscure = obscureContext
                            .watch<ObscureCubit>()
                            .state
                            .obscure;
                        return CustomTextField(
                          focusNode: consumerContext
                              .read<UserCubit>()
                              .signUpPasswordFocuseNode,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) {
                            if (state is! SignUpLoading) {
                              consumerContext.read<UserCubit>().signUp();
                            }
                          },
                          controller: consumerContext
                              .read<UserCubit>()
                              .signUpPassword,
                          text: l10n.password,
                          obscure: obscure,

                          suffix: IconButton(
                            icon: Icon(
                              obscure ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                              color: context.colorScheme.secondary,
                            ),
                            onPressed: obscureContext
                                .read<ObscureCubit>()
                                .obscureChange,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: context.screenHeight * 0.02),
                  Spacer(),

                  state is SignUpLoading
                      ? CircularProgressIndicator()
                      : CustomButton(
                          text: l10n.createAccount,
                          onTap: consumerContext.read<UserCubit>().signUp,
                        ),

                  SizedBox(height: context.screenHeight * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${l10n.alreadyHaveAccount} ',
                        style: context.textTheme.titleMedium,
                      ),
                      CustomTextButton(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        text: l10n.login,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
