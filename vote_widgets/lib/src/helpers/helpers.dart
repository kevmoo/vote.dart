import 'dart:ui';

import 'package:flutter/painting.dart';

import '../model/candidate.dart';

Map<TCandidate, Color>
    huesForCandidates<TCandidate extends Comparable<TCandidate>>(
  Iterable<TCandidate> candidates,
) {
  final sorted = candidates.toList()..sort();
  final delta = 360 / sorted.length;
  var offset = 0;
  return Map.fromEntries(sorted.map(
    (e) => MapEntry(
      e,
      e is Candidate
          ? (e as Candidate).color
          : HSVColor.fromAHSV(1.0, offset++ * delta, 0.5, 1).toColor(),
    ),
  ));
}
