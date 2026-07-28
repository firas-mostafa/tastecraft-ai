import 'package:flutter/material.dart';
import 'package:recipe_app/helpers/responsive/size_helper_extension.dart'
    show SizeHelperExtension;
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart'
    show ThemeHelperExtension;

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.suffix,
    required this.text,
    this.obscure = false,
    this.minLines = 1,
    this.maxLines = 1,

    this.validator,
    required this.textInputAction,
    required this.onFieldSubmitted,
    required this.focusNode,
    this.onChanged,
  });
  final int minLines;
  final int maxLines;
  final TextInputAction textInputAction;
  final Function(String) onFieldSubmitted;
  final void Function(String)? onChanged;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool obscure;
  final Widget? suffix;
  final String text;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      minLines: minLines,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      focusNode: focusNode,
      style: context.textTheme.bodyMedium!.copyWith(
        color: context.colorScheme.primary,
      ),
      controller: controller,
      obscureText: obscure,

      textAlignVertical: TextAlignVertical.center,
      cursorOpacityAnimates: true,
      cursorHeight: context.setMineSize(30),
      onTapOutside: (PointerDownEvent event) {
        FocusScope.of(context).unfocus();
      },
      decoration: InputDecoration(
        hintStyle: context.textTheme.bodyMedium!.copyWith(
          color: context.colorScheme.outline,
        ),
        suffixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.setMineSize(5)),
          child: suffix,
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: context.setMineSize(10),
          horizontal: context.setMineSize(20),
        ),

        hintText: text,
        filled: true,
        fillColor: context.colorScheme.surfaceContainer,
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.setMineSize(10)),

          borderSide: BorderSide(color: context.colorScheme.error),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.setMineSize(10)),
          borderSide: BorderSide(color: context.colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.setMineSize(10)),
          borderSide: BorderSide(color: context.colorScheme.primary),
        ),
      ),
    );
  }
}
