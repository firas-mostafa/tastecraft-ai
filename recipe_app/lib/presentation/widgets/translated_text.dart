import 'package:flutter/material.dart';
import 'package:recipe_app/helpers/translation/translation_service.dart';

class TranslatedText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const TranslatedText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  State<TranslatedText> createState() => _TranslatedTextState();
}

class _TranslatedTextState extends State<TranslatedText> {
  String _displayText = '';

  @override
  void initState() {
    super.initState();
    _displayText = widget.text;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _translate();
  }

  @override
  void didUpdateWidget(covariant TranslatedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _displayText = widget.text;
      _translate();
    }
  }

  Future<void> _translate() async {
    if (!mounted) return;
    final translated = await TranslationService().translate(widget.text, context);
    if (mounted && translated != _displayText) {
      setState(() {
        _displayText = translated;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayText,
      style: widget.style,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      overflow: widget.overflow,
    );
  }
}
