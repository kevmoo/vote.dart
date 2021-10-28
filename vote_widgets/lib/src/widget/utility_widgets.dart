import 'package:flutter/material.dart';

class CellPadding extends StatelessWidget {
  final Widget child;
  final Color? background;
  final String? tooltip;

  const CellPadding({
    Key? key,
    this.background,
    required this.child,
    this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final container = Container(
      padding: const EdgeInsets.all(9),
      alignment: Alignment.center,
      color: background,
      child: child,
    );

    if (tooltip == null) return container;

    return Tooltip(
      message: tooltip!,
      child: container,
    );
  }
}

class PaddedText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Color? background;
  final TextAlign textAlign;
  final String? tooltip;

  const PaddedText({
    Key? key,
    required this.text,
    this.textAlign = TextAlign.center,
    this.background,
    this.style,
    this.tooltip,
  }) : super(key: key);

  PaddedText.bits({
    Key? key,
    required this.text,
    this.textAlign = TextAlign.center,
    this.background,
    this.tooltip,
    FontStyle? fontStyle,
    FontWeight? fontWeight,
  })  : style = (fontStyle == null && fontWeight == null)
            ? null
            : TextStyle(fontStyle: fontStyle, fontWeight: fontWeight),
        super(key: key);

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
