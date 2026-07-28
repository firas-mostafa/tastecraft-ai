import 'package:flutter/material.dart';
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart';
import 'package:recipe_app/helpers/responsive/size_helper_extension.dart';
import 'package:recipe_app/l10n/app_localizations.dart';

class BmiCard extends StatelessWidget {
  final double? bmi;
  const BmiCard({super.key, required this.bmi});

  @override
  Widget build(BuildContext context) {
    if (bmi == null) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context)!;
    final (category, color, desc) = bmi! < 18.5
        ? (l10n.bmiUnderweight, Colors.orange, l10n.bmiUnderweightDesc)
        : bmi! < 25
            ? (l10n.bmiNormal, Colors.green, l10n.bmiNormalDesc)
            : bmi! < 30
                ? (l10n.bmiOverweight, Colors.orange, l10n.bmiOverweightDesc)
                : (l10n.bmiObese, Colors.red, l10n.bmiObeseDesc);

    return Container(
      padding: EdgeInsets.all(context.setMineSize(12)),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(context.setMineSize(12)),
        border: Border.all(color: color.withAlpha(50), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("BMI: ${bmi!.toStringAsFixed(1)}", style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: color)),
              Text(category, style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: color)),
            ],
          ),
          const SizedBox(height: 6),
          Text(desc, style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.onSurfaceVariant), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
