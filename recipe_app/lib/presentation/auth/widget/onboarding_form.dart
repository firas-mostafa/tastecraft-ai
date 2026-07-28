import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/helpers/responsive/size_helper_extension.dart';
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart';
import 'package:recipe_app/logic/user_cubit/user_cubit.dart';
import 'package:recipe_app/presentation/widgets/custom_button.dart';
import 'package:recipe_app/presentation/widgets/custom_text_field.dart';
import 'package:recipe_app/l10n/app_localizations.dart';
import 'package:recipe_app/helpers/health/health_helper.dart';
import 'package:recipe_app/presentation/profile/widgets/bmi_card.dart';
import 'package:recipe_app/presentation/profile/widgets/chip_selection_box.dart';
import 'package:recipe_app/presentation/auth/widget/onboarding_basic_inputs.dart';

class OnboardingForm extends StatefulWidget {
  final UserState state;
  const OnboardingForm({super.key, required this.state});

  @override
  State<OnboardingForm> createState() => _OnboardingFormState();
}

class _OnboardingFormState extends State<OnboardingForm> {
  final _formKey = GlobalKey<FormState>();

  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _promptController = TextEditingController();

  final _ageFocus = FocusNode();
  final _heightFocus = FocusNode();
  final _weightFocus = FocusNode();
  final _promptFocus = FocusNode();

  String _selectedGender = 'Male';
  final List<String> _selectedDiseases = [];
  final List<String> _selectedAllergies = [];

  List<String> _availableDiseases = [], _availableAllergies = [];
  double? _bmi;
  bool _initialized = false, _googleFitConnected = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final l10n = AppLocalizations.of(context)!;
      _selectedGender = l10n.male;
      _availableDiseases = [l10n.diabetes, l10n.hypertension];
      _availableAllergies = [l10n.eggs, l10n.chocolate, l10n.peanuts, l10n.glutenFree];
      _checkGoogleFitStatus();
      _initialized = true;
    }
  }

  @override
  void initState() {
    super.initState();
    _heightController.addListener(_calculateBMI);
    _weightController.addListener(_calculateBMI);
  }

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _promptController.dispose();
    _ageFocus.dispose();
    _heightFocus.dispose();
    _weightFocus.dispose();
    _promptFocus.dispose();
    super.dispose();
  }

  void _calculateBMI() {
    final h = double.tryParse(_heightController.text), w = double.tryParse(_weightController.text);
    setState(() => _bmi = (h != null && w != null && h > 0 && w > 0) ? w / ((h / 100) * (h / 100)) : null);
  }

  Future<void> _checkGoogleFitStatus() async {
    final authorized = await HealthHelper.hasPermissions();
    setState(() => _googleFitConnected = authorized);
  }

  Future<void> _toggleGoogleFit(bool connect) async {
    final l10n = AppLocalizations.of(context)!;
    bool authorized = connect ? await HealthHelper.requestPermissions() : false;
    setState(() => _googleFitConnected = authorized);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(connect ? (authorized ? l10n.googleFitConnected : l10n.googleFitPermissionsRequired) : l10n.googleFitDisconnected),
      ));
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final diseasesStr = _selectedDiseases.join(', ');
      var allergiesStr = _selectedAllergies.join(', ');
      if (_promptController.text.isNotEmpty) {
        allergiesStr += ' | AI Instructions: ${_promptController.text}';
      }
      context.read<UserCubit>().patchHealthProfile(
            int.parse(_ageController.text),
            double.parse(_heightController.text),
            double.parse(_weightController.text),
            diseasesStr,
            allergiesStr,
          );
    }
  }

  Future<void> _showAddOptionDialog(String title, bool isDisease) async {
    final controller = TextEditingController();
    final l10n = AppLocalizations.of(context)!;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: l10n.enterName, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
          ElevatedButton(
            onPressed: () {
              final item = controller.text.trim();
              if (item.isNotEmpty) {
                setState(() {
                  if (isDisease) {
                    _availableDiseases.add(item);
                    _selectedDiseases..add(item)..remove(l10n.noneLabel);
                  } else {
                    _availableAllergies.add(item);
                    _selectedAllergies..add(item)..remove(l10n.noneLabel);
                  }
                });
              }
              Navigator.pop(context);
            },
            child: Text(l10n.add),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderInfo(context, l10n),
          SizedBox(height: context.setHeight(24)),
          OnboardingBasicInputs(
            ageController: _ageController,
            weightController: _weightController,
            heightController: _heightController,
            ageFocus: _ageFocus,
            weightFocus: _weightFocus,
            heightFocus: _heightFocus,
            promptFocus: _promptFocus,
            selectedGender: _selectedGender,
            onGenderChanged: (val) => setState(() => _selectedGender = val),
          ),
          SizedBox(height: context.setHeight(24)),
          if (_bmi != null) ...[
            BmiCard(bmi: _bmi),
            SizedBox(height: context.setHeight(24)),
          ],
          ChipSelectionBox(
            title: l10n.chronicDiseases,
            description: l10n.chronicDiseasesDesc,
            availableOptions: _availableDiseases,
            selectedOptions: _selectedDiseases,
            isDisease: true,
            onAddPressed: () => _showAddOptionDialog(l10n.addDisease, true),
            onChanged: (newList) => setState(() => _selectedDiseases..clear()..addAll(newList)),
          ),
          SizedBox(height: context.setHeight(24)),
          ChipSelectionBox(
            title: l10n.foodAllergies,
            description: l10n.foodAllergiesDesc,
            availableOptions: _availableAllergies,
            selectedOptions: _selectedAllergies,
            isDisease: false,
            onAddPressed: () => _showAddOptionDialog(l10n.addAllergy, false),
            onChanged: (newList) => setState(() => _selectedAllergies..clear()..addAll(newList)),
          ),
          SizedBox(height: context.setHeight(24)),
          Text(l10n.aiInstructions, style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: context.setHeight(8)),
          CustomTextField(
            controller: _promptController,
            text: l10n.aiInstructionsHint,
            focusNode: _promptFocus,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _submit(),
            minLines: 3,
            maxLines: 4,
          ),
          SizedBox(height: context.setHeight(24)),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.setMineSize(16)), side: BorderSide(color: context.colorScheme.outlineVariant)),
            child: Padding(
              padding: EdgeInsets.all(context.setMineSize(16)),
              child: Row(children: [
                Icon(Icons.fitness_center_rounded, size: 28, color: _googleFitConnected ? Colors.green : context.colorScheme.primary),
                SizedBox(width: context.setMineSize(16)),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(l10n.connectGoogleFit, style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: context.setHeight(2)),
                  Text(_googleFitConnected ? l10n.googleFitConnected : l10n.googleFitPermissionsRequired, style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.onSurfaceVariant)),
                ])),
                Switch(value: _googleFitConnected, onChanged: _toggleGoogleFit, activeThumbColor: Colors.green),
              ]),
            ),
          ),
          SizedBox(height: context.setHeight(32)),
          CustomButton(
            onTap: widget.state is PatchMeLoading ? null : _submit,
            text: widget.state is PatchMeLoading ? l10n.saving : l10n.completeOnboarding,
          ),
          SizedBox(height: context.setHeight(32)),
        ],
      ),
    );
  }

  Widget _buildHeaderInfo(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        Text(
          l10n.healthProfileSubtitle,
          style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: context.colorScheme.primary),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: context.setHeight(8)),
        Text(
          l10n.healthProfileDesc,
          style: context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
