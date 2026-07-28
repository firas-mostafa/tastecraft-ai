import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/presentation/widgets/custom_dialog.dart' show CustomDialog;
import 'package:recipe_app/helpers/responsive/size_helper_extension.dart' show SizeHelperExtension;
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart' show ThemeHelperExtension;
import 'package:recipe_app/logic/user_cubit/user_cubit.dart';
import 'package:recipe_app/presentation/widgets/custom_button.dart' show CustomButton;
import 'package:recipe_app/presentation/widgets/custom_text_field.dart' show CustomTextField;
import 'package:recipe_app/l10n/app_localizations.dart';
import 'package:recipe_app/helpers/health/health_helper.dart';
import 'package:recipe_app/presentation/profile/widgets/bmi_card.dart';
import 'package:recipe_app/presentation/profile/widgets/chip_selection_box.dart';
class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  List<String> _availableDiseases = [], _availableAllergies = [];
  bool _initialized = false, _googleFitConnected = false;
  double? _bmi;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final l10n = AppLocalizations.of(context)!;
      _availableDiseases = [l10n.diabetes, l10n.hypertension];
      _availableAllergies = [l10n.eggs, l10n.chocolate, l10n.peanuts, l10n.glutenFree];
      
      final userCubit = context.read<UserCubit>();
      if (userCubit.state is GetMeSuccess) {
        userCubit.prepopulateProfileEdit((userCubit.state as GetMeSuccess).user);
        for (var d in userCubit.patchMeSelectedDiseases) {
          if (!_availableDiseases.contains(d) && d != l10n.noneLabel) _availableDiseases.add(d);
        }
        for (var a in userCubit.patchMeSelectedAllergies) {
          if (!_availableAllergies.contains(a) && a != l10n.noneLabel) _availableAllergies.add(a);
        }
      }
      
      _calculateBMI();
      userCubit.patchMeHeight.addListener(_calculateBMI);
      userCubit.patchMeWeight.addListener(_calculateBMI);
      _checkGoogleFitStatus();
      _initialized = true;
    }
  }

  void _calculateBMI() {
    final userCubit = context.read<UserCubit>();
    final h = double.tryParse(userCubit.patchMeHeight.text), w = double.tryParse(userCubit.patchMeWeight.text);
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

  Future<void> _showAddOptionDialog(String title, bool isDisease) async {
    final controller = TextEditingController();
    final l10n = AppLocalizations.of(context)!;
    final userCubit = context.read<UserCubit>();
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
                    userCubit.patchMeSelectedDiseases..add(item)..remove(l10n.noneLabel);
                  } else {
                    _availableAllergies.add(item);
                    userCubit.patchMeSelectedAllergies..add(item)..remove(l10n.noneLabel);
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
    final userCubit = context.read<UserCubit>();
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editProfile, style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: context.colorScheme.primary)),
        centerTitle: true,
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back_ios_rounded, size: context.setMineSize(24))),
      ),
      body: BlocConsumer<UserCubit, UserState>(
        listener: (context, state) {
          if (state is PatchMeSuccess) {
            userCubit.getMe();
            Navigator.pop(context);
            showDialog(context: context, builder: (c) => CustomDialog(icon: Icons.mood_rounded, backgroundColor: c.colorScheme.primaryContainer, text: l10n.successRecipeUpdate, textColor: c.colorScheme.onPrimaryContainer));
          } else if (state is PatchMeFailure) {
            showDialog(context: context, builder: (c) => CustomDialog(icon: Icons.sentiment_dissatisfied_rounded, backgroundColor: c.colorScheme.errorContainer, text: state.errorMessage, textColor: c.colorScheme.onErrorContainer));
            userCubit.getMe();
          }
        },
        builder: (context, state) {
          if (state is PatchMeLoading) return const Center(child: CircularProgressIndicator());
          return SingleChildScrollView(
            padding: EdgeInsets.all(context.setMineSize(24)),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSectionCard(title: l10n.personal, icon: Icons.person_outline_rounded, children: [
                    CustomTextField(controller: userCubit.patchMeName, text: l10n.name, textInputAction: TextInputAction.next, focusNode: userCubit.patchMeNameFocuseNode, onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(userCubit.patchMeEmailFocuseNode)),
                    SizedBox(height: context.setHeight(12)),
                    CustomTextField(controller: userCubit.patchMeEmail, text: l10n.email, textInputAction: TextInputAction.next, focusNode: userCubit.patchMeEmailFocuseNode, onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(userCubit.patchMePasswordFocuseNode)),
                    SizedBox(height: context.setHeight(12)),
                    CustomTextField(controller: userCubit.patchMePassword, text: "${l10n.password} (${localeIsArabic() ? 'اتركه فارغاً للتخطي' : 'leave empty to keep same'})", textInputAction: TextInputAction.next, focusNode: userCubit.patchMePasswordFocuseNode, obscure: true, onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(userCubit.patchMeAgeFocuseNode)),
                  ]),
                  SizedBox(height: context.setHeight(20)),
                  _buildSectionCard(title: l10n.healthProfileTitle, icon: Icons.speed_rounded, children: [
                    Row(children: [
                      Expanded(child: _buildLabeledField(label: l10n.ageLabel, controller: userCubit.patchMeAge, focusNode: userCubit.patchMeAgeFocuseNode, nextFocusNode: userCubit.patchMeWeightFocuseNode, hint: '28')),
                      SizedBox(width: context.setMineSize(16)),
                      Expanded(child: _buildLabeledField(label: l10n.weightLabel, controller: userCubit.patchMeWeight, focusNode: userCubit.patchMeWeightFocuseNode, nextFocusNode: userCubit.patchMeHeightFocuseNode, hint: '70')),
                    ]),
                    SizedBox(height: context.setHeight(16)),
                    _buildLabeledField(label: l10n.heightLabel, controller: userCubit.patchMeHeight, focusNode: userCubit.patchMeHeightFocuseNode, nextFocusNode: userCubit.patchMeAiInstructionsFocuseNode, hint: '175'),
                    if (_bmi != null) ...[SizedBox(height: context.setHeight(16)), BmiCard(bmi: _bmi)],
                  ]),
                  SizedBox(height: context.setHeight(20)),
                  ChipSelectionBox(
                    title: l10n.chronicDiseases,
                    description: l10n.chronicDiseasesDesc,
                    availableOptions: _availableDiseases,
                    selectedOptions: userCubit.patchMeSelectedDiseases,
                    isDisease: true,
                    onAddPressed: () => _showAddOptionDialog(l10n.addDisease, true),
                    onChanged: (newList) => setState(() => userCubit.patchMeSelectedDiseases = newList),
                  ),
                  SizedBox(height: context.setHeight(20)),
                  ChipSelectionBox(
                    title: l10n.foodAllergies,
                    description: l10n.foodAllergiesDesc,
                    availableOptions: _availableAllergies,
                    selectedOptions: userCubit.patchMeSelectedAllergies,
                    isDisease: false,
                    onAddPressed: () => _showAddOptionDialog(l10n.addAllergy, false),
                    onChanged: (newList) => setState(() => userCubit.patchMeSelectedAllergies = newList),
                  ),
                  SizedBox(height: context.setHeight(20)),
                  _buildSectionCard(title: l10n.aiInstructions, icon: Icons.auto_awesome, children: [
                    CustomTextField(
                      controller: userCubit.patchMeAiInstructions,
                      text: l10n.aiInstructionsHint,
                      focusNode: userCubit.patchMeAiInstructionsFocuseNode,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                      minLines: 3,
                      maxLines: 4,
                    ),
                  ]),
                  SizedBox(height: context.setHeight(20)),
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
                  CustomButton(onTap: () { if (_formKey.currentState!.validate()) userCubit.patchMe(); }, text: l10n.saveChanges),
                  SizedBox(height: context.setHeight(40)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required List<Widget> children}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.setMineSize(16)), side: BorderSide(color: context.colorScheme.outlineVariant)),
      child: Padding(
        padding: EdgeInsets.all(context.setMineSize(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(icon, color: context.colorScheme.primary, size: 22),
              SizedBox(width: context.setMineSize(8)),
              Text(title, style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: context.colorScheme.primary)),
            ]),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildLabeledField({required String label, required TextEditingController controller, required FocusNode focusNode, required FocusNode? nextFocusNode, String hint = ''}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.textTheme.titleSmall),
        SizedBox(height: context.setHeight(8)),
        CustomTextField(
          controller: controller,
          text: hint,
          focusNode: focusNode,
          textInputAction: nextFocusNode != null ? TextInputAction.next : TextInputAction.done,
          onFieldSubmitted: (_) { if (nextFocusNode != null) FocusScope.of(context).requestFocus(nextFocusNode); },
        ),
      ],
    );
  }

  bool localeIsArabic() => Localizations.localeOf(context).languageCode == 'ar';
}
