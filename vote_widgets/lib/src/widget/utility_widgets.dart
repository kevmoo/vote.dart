import 'package:flutter/material.dart';

class CellPadding extends StatelessWidget {
  final Widget child;
  final Color? background;
  const CellPadding({
    Key? key,
    this.background,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(9),
        alignment: Alignment.center,
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
    this.background,
    this.style,
  }) : super(key: key);

  PaddedText.bits({
    Key? key,
    required this.text,
    this.textAlign = TextAlign.center,
    this.background,
    FontStyle? fontStyle,
  })  : style = (fontStyle == null) ? null : TextStyle(fontStyle: fontStyle),
        super(key: key);

  @override
  Widget build(BuildContext context) => CellPadding(
        background: background,
        child: Text(
          text,
          style: style,
          strutStyle: const StrutStyle(forceStrutHeight: true, height: 1),
          textAlign: textAlign,
        ),
      );
}
