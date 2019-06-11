import 'package:flutter_web/material.dart';

Widget tableHeader(String content) => Container(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Text(
        content,
        textScaleFactor: 0.6,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
