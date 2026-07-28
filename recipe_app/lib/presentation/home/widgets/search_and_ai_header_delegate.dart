import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart'
    show ThemeHelperExtension;
import 'package:recipe_app/helpers/responsive/size_helper_extension.dart'
    show SizeHelperExtension;
import 'header_title_widget.dart';
import 'translucent_ai_card.dart';

class SearchAndAiHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double safeAreaTop;
  final Widget searchWidget;

  SearchAndAiHeaderDelegate({
    required this.safeAreaTop,
    required this.searchWidget,
  });

  @override
  double get maxExtent => safeAreaTop + 185;

  @override
  double get minExtent => safeAreaTop + 65;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final double playableExtent = maxExtent - minExtent;
    final double t = (shrinkOffset / playableExtent).clamp(0.0, 1.0);

    // Fade out AI card and title row
    final double opacity = (1.0 - t * 1.5).clamp(0.0, 1.0);

    // Interpolate search bar position
    final double expandedSearchTop = safeAreaTop + 130;
    final double collapsedSearchTop = safeAreaTop + 10;
    final double searchTop =
        lerpDouble(expandedSearchTop, collapsedSearchTop, t) ??
        collapsedSearchTop;

    // Use dark container colors in dark mode so the background is always deep & dark
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color startColor = isDark
        ? context.colorScheme.primaryContainer
        : context.colorScheme.primary;
    final Color endColor = isDark
        ? context.colorScheme.tertiaryContainer
        : context.colorScheme.tertiary;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [startColor, endColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withAlpha(15),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 1. Header Title Row (AgriSphere style)
          Positioned(
            top: safeAreaTop + 10,
            left: context.setMineSize(20),
            right: context.setMineSize(20),
            height: context.setMineSize(35),
            child: Opacity(opacity: opacity, child: const HeaderTitleWidget()),
          ),
          // 2. Translucent AI Chat Card (Current Weather style)
          Positioned(
            top: safeAreaTop + 55,
            left: context.setMineSize(20),
            right: context.setMineSize(20),
            height: context.setMineSize(65),
            child: Opacity(opacity: opacity, child: const TranslucentAiCard()),
          ),
          // 3. Pinned Search Filter
          Positioned(
            top: searchTop,
            left: context.setMineSize(20),
            right: context.setMineSize(20),
            height: context.setMineSize(45),
            child: searchWidget,
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SearchAndAiHeaderDelegate oldDelegate) {
    return oldDelegate.safeAreaTop != safeAreaTop ||
        oldDelegate.searchWidget != searchWidget;
  }
}
