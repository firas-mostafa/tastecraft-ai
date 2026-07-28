import 'package:flutter/material.dart';
import 'package:recipe_app/helpers/responsive/size_helper_extension.dart';
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart';
import 'package:recipe_app/presentation/widgets/custom_text_field.dart';
import 'package:recipe_app/l10n/app_localizations.dart';

class OnboardingBasicInputs extends StatelessWidget {
  final TextEditingController ageController;
  final TextEditingController weightController;
  final TextEditingController heightController;
  final FocusNode ageFocus;
  final FocusNode weightFocus;
  final FocusNode heightFocus;
  final FocusNode promptFocus;
  final String selectedGender;
  final ValueChanged<String> onGenderChanged;

  const OnboardingBasicInputs({
    super.key,
    required this.ageController,
    required this.weightController,
    required this.heightController,
    required this.ageFocus,
    required this.weightFocus,
    required this.heightFocus,
    required this.promptFocus,
    required this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.ageLabel, style: context.textTheme.titleSmall),
                  SizedBox(height: context.setHeight(8)),
                  CustomTextField(
                    controller: ageController,
                    text: 'e.g. 28',
                    focusNode: ageFocus,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(weightFocus),
                    validator: (val) {
                      if (val == null || val.isEmpty) return l10n.requiredField;
                      if (int.tryParse(val) == null) return l10n.invalidField;
                      return null;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(width: context.setMineSize(16)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.genderLabel, style: context.textTheme.titleSmall),
                  SizedBox(height: context.setHeight(8)),
                  Container(
                    height: context.setHeight(60),
                    padding: EdgeInsets.symmetric(horizontal: context.setMineSize(16)),
                    decoration: BoxDecoration(
                      border: Border.all(color: context.colorScheme.outlineVariant),
                      borderRadius: BorderRadius.circular(context.setMineSize(12)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedGender,
                        isExpanded: true,
                        items: [l10n.male, l10n.female].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          if (newValue != null) onGenderChanged(newValue);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: context.setHeight(16)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.weightLabel, style: context.textTheme.titleSmall),
                  SizedBox(height: context.setHeight(8)),
                  CustomTextField(
                    controller: weightController,
                    text: 'e.g. 74',
                    focusNode: weightFocus,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(heightFocus),
                    validator: (val) {
                      if (val == null || val.isEmpty) return l10n.requiredField;
                      if (double.tryParse(val) == null) return l10n.invalidField;
                      return null;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(width: context.setMineSize(16)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.heightLabel, style: context.textTheme.titleSmall),
                  SizedBox(height: context.setHeight(8)),
                  CustomTextField(
                    controller: heightController,
                    text: 'e.g. 176',
                    focusNode: heightFocus,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(promptFocus),
                    validator: (val) {
                      if (val == null || val.isEmpty) return l10n.requiredField;
                      if (double.tryParse(val) == null) return l10n.invalidField;
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
