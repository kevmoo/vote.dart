import 'package:flutter_web_ui/ui.dart';

import '../helpers/hsl_color.dart';

abstract class Candidate implements Comparable<Candidate> {
  static const candidateString = '🙎';

  final String id;

  final double hue;

  final Color color, darkColor;

  Candidate(this.id, this.hue)
      : color = HslColor(hue, 1, 0.8).toColor(),
        darkColor = HslColor(hue, 0.8, 0.7).toColor();

  @override
  int compareTo(Candidate other) => id.compareTo(other.id);

  @override
  bool operator ==(other) => other is Candidate && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Candidate($id)';
}
