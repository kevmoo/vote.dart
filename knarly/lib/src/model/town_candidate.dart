import 'package:flutter_web_ui/ui.dart';

import '../hsl_color.dart';

class TownCandidate implements Comparable<TownCandidate> {
  static const _capitalACharCode = 65;

  final String id;

  final Color color, dartColor;

  final Point location;

  TownCandidate(int index, this.location)
      : assert(index >= 0),
        assert(index < _maxCandidateCount),
        color = HslColor(_candidateHues[index], 1, 0.8).toColor(),
        dartColor = HslColor(_candidateHues[index], 0.8, 0.7).toColor(),
        id = String.fromCharCode(index + _capitalACharCode);

  @override
  int compareTo(TownCandidate other) => id.compareTo(other.id);

  @override
  bool operator ==(other) => other is TownCandidate && id == other.id;

  @override
  int get hashCode => id.hashCode;
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
