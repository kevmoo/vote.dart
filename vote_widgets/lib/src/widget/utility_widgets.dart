import 'package:flutter/material.dart';

class CelPadding extends StatelessWidget {
  final Widget child;
  final Color? background;
  const CelPadding({
    Key? key,
    this.background,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(9),
        color: background,
        child: child,
      );
}

class PaddedText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Color? background;
  final TextAlign textAlign;

  const PaddedText({
    Key? key,
    required this.text,
    this.textAlign = TextAlign.center,
    this.style,
    this.background,
  }) : super(key: key);

  PaddedText.bits({
    Key? key,
    required this.text,
    this.textAlign = TextAlign.center,
    this.background,
    FontStyle? fontStyle,
    FontWeight? fontWeight,
  })  : style = (fontStyle == null && fontWeight == null)
            ? null
            : TextStyle(fontStyle: fontStyle, fontWeight: fontWeight),
        super(key: key);

  @override
  Widget build(BuildContext context) => CelPadding(
        background: background,
        child: Text(
          text,
          style: style,
          strutStyle: const StrutStyle(forceStrutHeight: true, height: 1),
          textAlign: textAlign,
        ),
      );
}
