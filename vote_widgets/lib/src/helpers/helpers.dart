import 'dart:ui';

import 'hsl_color.dart';

Map<TCandidate, Color>
    huesForCandidates<TCandidate extends Comparable<TCandidate>>(
  Iterable<TCandidate> candidates,
) {
  final sorted = candidates.toList()..sort();
  final delta = 360 / sorted.length;
  var offset = 0;
  return Map.fromEntries(sorted.map(
    (e) => MapEntry(e, HslColor(offset++ * delta, 1, 0.8).toColor()),
  ));
}
