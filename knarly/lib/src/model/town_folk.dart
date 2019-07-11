import 'dart:math' as math;

import 'package:flutter_web_ui/ui.dart';

import 'candidate.dart';
import 'voter.dart';

class TownCandidate extends Candidate {
  static const candidateSpacing = 5.0;

  final Point location;

  final math.Point<int> intLocation;

  TownCandidate(String id, double hue, this.intLocation)
      : location = _unfixPoint(intLocation),
        super(id, hue);

  factory TownCandidate.letter(int index, math.Point<int> intLocation) {
    assert(index >= 0);
    assert(index < _maxCandidateCount);
    return TownCandidate(String.fromCharCode(index + _capitalACharCode),
        _candidateHues[index], intLocation);
  }

  @override
  int compareTo(Candidate other) => id.compareTo(other.id);

  @override
  bool operator ==(other) => other is TownCandidate && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'TownCandidate($id)';
}

math.Point<int> fixPoint(Point value) => math.Point(
      (value.x / TownCandidate.candidateSpacing - 1).round(),
      (value.y / TownCandidate.candidateSpacing - 1).round(),
    );

Point _unfixPoint(math.Point<int> value) => Point(
      (value.x + 1) * TownCandidate.candidateSpacing,
      (value.y + 1) * TownCandidate.candidateSpacing,
    );

class TownVoter extends Voter {
  final Point location;
  final List<TownCandidate> closestCandidates;

  TownVoter(int id, this.location, this.closestCandidates) : super(id);
}

const _capitalACharCode = 65;
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
