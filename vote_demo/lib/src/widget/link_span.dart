import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

String _trimUrl(String url) {
  const httpsStart = 'https://';
  if (url.startsWith(httpsStart)) {
    return url.substring(httpsStart.length);
  }
  return url;
}

TextSpan linkSpan(
  String url, {
  String? text,
  Color linkColor = Colors.lightBlue,
}) =>
    TextSpan(
      text: text ?? _trimUrl(url),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          launch(url);
        },
      style: TextStyle(
        decoration: TextDecoration.underline,
        color: linkColor,
      ),
      mouseCursor: SystemMouseCursors.click,
    );
