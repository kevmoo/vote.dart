import 'package:flutter/painting.dart';

const candidateString = '🙎';

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
          HSVColor.fromAHSV(1, candidateHues[index], colorSaturation, 1)
              .toColor(),
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

const colorSaturation = 0.3;

const int maxCandidateCount = 26;

final candidateHues = _slice(maxCandidateCount, 360, 3);

List<double> _slice(int itemCount, num maxValue, int sliceCount) {
  assert(itemCount > 0);
  assert(maxValue > 0);
  assert(sliceCount > 1);

  final values = List<double>.filled(itemCount, 0);
  var index = 0;

  var sliceSize = maxValue / sliceCount;

  for (var i = 0; i < sliceCount; i++) {
    if (index == itemCount) {
      return values;
    } else {
      values[index++] = i * sliceSize;
    }
  }

  for (;;) {
    final startCount = index;
    sliceSize = maxValue / (startCount * 2);

    for (var i = 0; i < startCount; i++) {
      if (index == itemCount) {
        return values;
      } else {
        values[index++] = values[i] + sliceSize;
      }
    }
  }
}

extension SetExtentions<T> on Set<T> {
  bool sameItems(Set<T> other) =>
      length == other.length && difference(other).isEmpty;
}
