import 'dart:math' as math;

import 'package:flutter_web_ui/ui.dart';

import '../helpers/hsl_color.dart';

class TownCandidate implements Comparable<TownCandidate> {
  static const candidateSpacing = 5.0;
  static const candidateString = '🙎';

  static const _capitalACharCode = 65;

  final int index;

  final String id;

  final Color color, darkColor;

  final Point location;

  final math.Point<int> intLocation;

  TownCandidate(this.index, this.intLocation)
      : assert(index >= 0),
        assert(index < _maxCandidateCount),
        location = _unfixPoint(intLocation),
        color = HslColor(_candidateHues[index], 1, 0.8).toColor(),
        darkColor = HslColor(_candidateHues[index], 0.8, 0.7).toColor(),
        id = String.fromCharCode(index + _capitalACharCode);

  @override
  int compareTo(TownCandidate other) => id.compareTo(other.id);

  @override
  bool operator ==(other) => other is TownCandidate && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'TownCandidate($id)';
}

final _candidateHues = _slice(_maxCandidateCount, 360, 3);
const int _maxCandidateCount = 26;

List<double> _slice(int itemCount, num maxValue, int sliceCount) {
  assert(itemCount > 0);
  assert(maxValue > 0);
  assert(sliceCount > 1);

  final values = List<double>(itemCount);
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

math.Point<int> fixPoint(Point value) => math.Point(
      (value.x / TownCandidate.candidateSpacing - 1).round(),
      (value.y / TownCandidate.candidateSpacing - 1).round(),
    );

Point _unfixPoint(math.Point<int> value) => Point(
      (value.x + 1) * TownCandidate.candidateSpacing,
      (value.y + 1) * TownCandidate.candidateSpacing,
    );
