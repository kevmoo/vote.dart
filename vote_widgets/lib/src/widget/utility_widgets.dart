import 'package:flutter/material.dart';

class const CellPadding({
  super.key,
  final Color? background,
  required final Widget child,
  final String? tooltip,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final container = Container(
      padding: const EdgeInsets.all(9),
      alignment: Alignment.center,
      color: background,
      child: child,
    );

    if (tooltip == null) return container;

    return Tooltip(message: tooltip!, child: container);
  }
}

class PaddedText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Color? background;
  final TextAlign textAlign;
  final String? tooltip;

  const new({
    super.key,
    required this.text,
    this.textAlign = TextAlign.center,
    this.background,
    this.style,
    this.tooltip,
  });

  new bits({
    super.key,
    required this.text,
    this.textAlign = TextAlign.center,
    this.background,
    this.tooltip,
    FontStyle? fontStyle,
    FontWeight? fontWeight,
  }) : style = (fontStyle == null && fontWeight == null)
           ? null
           : TextStyle(fontStyle: fontStyle, fontWeight: fontWeight);

  @override
  Widget build(BuildContext context) => CellPadding(
    tooltip: tooltip,
    background: background,
    child: Text(
      text,
      style: style,
      strutStyle: const StrutStyle(forceStrutHeight: true, height: 1),
      textAlign: textAlign,
    ),
  );
}
