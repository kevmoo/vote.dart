import 'package:flutter/painting.dart';
import 'package:vote_simulation/vote_simulation.dart';

export 'package:vote_simulation/vote_simulation.dart' show Candidate;

extension CandidateColorExtension on Candidate {
  Color get color => HSVColor.fromAHSV(1.0, hue, colorSaturation, 1).toColor();

  Color get darkColor => HSVColor.fromAHSV(1.0, hue, 0.5, 0.95).toColor();
}
