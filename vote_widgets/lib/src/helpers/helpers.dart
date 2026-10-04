import 'package:flutter/painting.dart';
import 'package:vote_simulation/vote_simulation.dart';

export 'package:vote_simulation/vote_simulation.dart'
    show candidateHues, colorSaturation, maxCandidateCount;

Map<T, Color> huesForCandidates<T extends Comparable<T>>(
  Iterable<T> candidates,
) {
  final sorted = candidates.toList()..sort();

  if (sorted.length <= maxCandidateCount) {
    return Map.fromEntries(
      List.generate(
        sorted.length,
        (index) => MapEntry(
          sorted[index],
          HSVColor.fromAHSV(
            1,
            candidateHues[index],
            colorSaturation,
            1,
          ).toColor(),
        ),
      ),
    );
  }

  final delta = 360 / sorted.length;
  var offset = 0;
  return Map.fromEntries(
    sorted.map(
      (e) => MapEntry(
        e,
        HSVColor.fromAHSV(1.0, offset++ * delta, colorSaturation, 1).toColor(),
      ),
    ),
  );
}

extension SetExtentions<T> on Set<T> {
  bool sameItems(Set<T> other) =>
      length == other.length && difference(other).isEmpty;
}
