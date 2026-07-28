import 'package:flutter/material.dart';
import 'package:recipe_app/helpers/responsive/size_helper_extension.dart'
    show SizeHelperExtension;
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart'
    show ThemeHelperExtension;

class QuickInfoRow extends StatelessWidget {
  final String price;
  final num timeMinutes;
  final int tagCount;
  final int? calories;

  const QuickInfoRow({
    required this.price,
    required this.timeMinutes,
    required this.tagCount,
    this.calories,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _InfoChip(
            icon: Icons.attach_money_rounded,
            label: '$price\$',
            color: context.colorScheme.secondary,
          ),
        ),
        SizedBox(width: context.setMineSize(8)),
        Expanded(
          child: _InfoChip(
            icon: Icons.timer_outlined,
            label: '$timeMinutes min',
            color: context.colorScheme.primary,
          ),
        ),
        SizedBox(width: context.setMineSize(8)),
        Expanded(
          child: _InfoChip(
            icon: Icons.local_offer_outlined,
            label: '$tagCount tags',
            color: context.colorScheme.tertiary,
          ),
        ),
        if (calories != null && calories! > 0) ...[
          SizedBox(width: context.setMineSize(8)),
          Expanded(
            child: _InfoChip(
              icon: Icons.whatshot_rounded,
              label: '$calories kcal',
              color: Colors.orange.shade800,
            ),
          ),
        ],
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: context.setMineSize(12),
        horizontal: context.setMineSize(8),
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(context.setMineSize(14)),
        border: Border.all(color: color.withAlpha(60), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: context.setMineSize(22)),
          SizedBox(height: context.setMineSize(6)),
          Text(
            label,
            style: context.textTheme.titleSmall!.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
