import 'dart:io' show File;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/helpers/responsive/size_helper_extension.dart';
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart';
import 'package:recipe_app/logic/meal_plan_cubit/meal_plan_cubit.dart';
import 'package:recipe_app/logic/meal_plan_cubit/meal_plan_state.dart';
import 'package:recipe_app/l10n/app_localizations.dart';
import 'package:recipe_app/presentation/widgets/custom_button.dart';
import 'package:recipe_app/data/models/meal_plan_models/meal_plan_model.dart';
import 'package:pdf/pdf.dart' show PdfPageFormat, PdfColors;
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart' show Share, XFile;
import 'package:path_provider/path_provider.dart' show getTemporaryDirectory;
import '../widgets/day_card.dart';

class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({super.key});

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  final TextEditingController _promptController = TextEditingController();
  final FocusNode _promptFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    context.read<MealPlanCubit>().fetchMealPlan();
  }

  @override
  void dispose() {
    _promptController.dispose();
    _promptFocus.dispose();
    super.dispose();
  }

  Future<void> _exportMealPlanPdf(BuildContext context, MealPlanModel mealPlan) async {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Text(l10n.pdfGenerating),
          ],
        ),
      ),
    );

    String aiNotes = "";
    try {
      aiNotes = await context.read<MealPlanCubit>().getMealPlanAiNotes(locale);
    } catch (e) {
      debugPrint("Failed to load AI notes: $e");
    }

    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context pdfContext) {
            return [
              pw.Header(
                level: 0,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      locale == 'ar' ? 'خطة الوجبات الأسبوعية' : 'Weekly Meal Plan',
                      style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      DateTime.now().toString().split(' ')[0],
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              ...mealPlan.days.map((day) {
                return pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 15),
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        day.day,
                        style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.green800),
                      ),
                      pw.SizedBox(height: 8),
                      _buildPdfMealRow(locale == 'ar' ? 'الفطور' : 'Breakfast', day.breakfast),
                      _buildPdfMealRow(locale == 'ar' ? 'الغداء' : 'Lunch', day.lunch),
                      _buildPdfMealRow(locale == 'ar' ? 'العشاء' : 'Dinner', day.dinner),
                      _buildPdfMealRow(locale == 'ar' ? 'الحلوى' : 'Dessert', day.dessert),
                    ],
                  ),
                );
              }).toList(),
              if (aiNotes.isNotEmpty) ...[
                pw.SizedBox(height: 20),
                pw.Header(
                  level: 1,
                  child: pw.Text(
                    locale == 'ar' ? 'نصائح وإرشادات الشيف الذكي' : 'AI Chef Recommendations',
                    style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.orange900),
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Paragraph(
                  text: aiNotes,
                  style: const pw.TextStyle(fontSize: 12),
                ),
              ],
            ];
          },
        ),
      );

      final output = await getTemporaryDirectory();
      final file = File("${output.path}/meal_plan.pdf");
      await file.writeAsBytes(await pdf.save());

      if (context.mounted) Navigator.pop(context); // Close loading

      final xFile = XFile(file.path);
      await Share.shareXFiles([xFile], text: locale == 'ar' ? 'خطة وجباتي الأسبوعية' : 'My Weekly Meal Plan');
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to export PDF: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  pw.Widget _buildPdfMealRow(String label, List<MealPlanRecipeOption> options) {
    if (options.isEmpty) return pw.SizedBox.shrink();
    final titles = options.map((e) => e.title).join(', ');
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: 80,
            child: pw.Text(
              "$label: ",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Expanded(
            child: pw.Text(titles),
          ),
        ],
      ),
    );
  }

  Widget _buildPromptInput(BuildContext context, String hintText) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(context.setMineSize(24)),
      ),
      padding: EdgeInsets.only(
        left: context.setMineSize(16),
        right: context.setMineSize(8),
        top: context.setMineSize(12),
        bottom: context.setMineSize(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            controller: _promptController,
            focusNode: _promptFocus,
            minLines: 3,
            maxLines: 5,
            style: context.textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant.withAlpha(150),
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) {
              context.read<MealPlanCubit>().generateMealPlan(
                _promptController.text,
              );
            },
          ),
          SizedBox(height: context.setHeight(8)),
          Container(
            decoration: BoxDecoration(
              color: context.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_forward_ios_rounded,
                color: context.colorScheme.onPrimary,
                size: context.setMineSize(22),
              ),
              onPressed: () {
                context.read<MealPlanCubit>().generateMealPlan(
                  _promptController.text,
                );
              },
              constraints: const BoxConstraints(),
              padding: EdgeInsets.all(context.setMineSize(8)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.weeklyMealPlan,
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          BlocBuilder<MealPlanCubit, MealPlanState>(
            builder: (context, state) {
              if (state is MealPlanLoaded) {
                return IconButton(
                  icon: const Icon(Icons.picture_as_pdf_rounded),
                  onPressed: () => _exportMealPlanPdf(context, state.mealPlan),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<MealPlanCubit>().fetchMealPlan();
            },
          ),
        ],
      ),
      body: BlocBuilder<MealPlanCubit, MealPlanState>(
        builder: (context, state) {
          if (state is MealPlanLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MealPlanInitial) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(context.setMineSize(32)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.restaurant_menu,
                      size: 64,
                      color: context.colorScheme.outline,
                    ),
                    SizedBox(height: context.setHeight(16)),
                    Text(
                      l10n.mealPlanEmptyTitle,
                      style: context.textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: context.setHeight(24)),
                    _buildPromptInput(context, l10n.mealPlanPromptHint),
                  ],
                ),
              ),
            );
          } else if (state is MealPlanError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${l10n.errorPrefix}${state.message}'),
                  SizedBox(height: context.setHeight(16)),
                  CustomButton(
                    onTap: () => context.read<MealPlanCubit>().fetchMealPlan(),
                    text: l10n.retryBtn,
                  ),
                ],
              ),
            );
          } else if (state is MealPlanLoaded) {
            final days = state.mealPlan.days;
            return RefreshIndicator(
              onRefresh: () async {
                await context.read<MealPlanCubit>().fetchMealPlan();
              },
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(context.setMineSize(16)),
                    child: Column(
                      children: [
                        _buildPromptInput(
                          context,
                          l10n.mealPlanChangePromptHint,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: days.length,
                      itemBuilder: (context, index) {
                        return DayCard(day: days[index]);
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
