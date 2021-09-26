import 'package:flutter/painting.dart';

import '../helpers/helpers.dart';

class Candidate implements Comparable<Candidate> {
  final String id;

  final double hue;

  final Color color, darkColor;

  Candidate(this.id, this.hue)
      : color = HSVColor.fromAHSV(1.0, hue, colorSaturation, 1).toColor(),
        darkColor = HSVColor.fromAHSV(1.0, hue, 0.5, 0.95).toColor();

  @override
  int compareTo(Candidate other) => id.compareTo(other.id);

  @override
  bool operator ==(Object other) => other is Candidate && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => id;
}
