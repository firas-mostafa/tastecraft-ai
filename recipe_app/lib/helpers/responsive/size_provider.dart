import 'package:flutter/material.dart';

class SizeProvider extends InheritedWidget {
  final Size baseSize;
  final double width;
  final double hight;

  const SizeProvider({
    super.key,
    required this.baseSize,
    required this.width,
    required this.hight,
    required super.child,
  });

  static SizeProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SizeProvider>()!;
  }

  @override
  bool updateShouldNotify(covariant SizeProvider oldWidget) =>
      baseSize != oldWidget.baseSize ||
      width != oldWidget.width ||
      hight != oldWidget.hight ||
      child != oldWidget.child;
}
