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
        alignment: Alignment.center,
        padding: const EdgeInsets.all(9),
        color: background,
        child: child,
      );
}

class PaddedText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Color? background;

  const PaddedText({
    Key? key,
    required this.text,
    this.style,
    this.background,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => CelPadding(
        background: background,
        child: Text(
          text,
          style: style,
          strutStyle: const StrutStyle(forceStrutHeight: true, height: 1),
          textAlign: TextAlign.center,
        ),
      );
}
