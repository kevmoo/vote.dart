import 'dart:math';
import 'dart:ui';

import 'candidate.dart';
import 'voter.dart';

class TownCandidate extends Candidate {
  static const candidateSpacing = 5.0;

  final Point<double> location;

  final Point<int> intLocation;

  TownCandidate(String id, double hue, this.intLocation)
      : location = _unfixPoint(intLocation),
        super(id, hue);

  factory TownCandidate.letter(int index, Point<int> intLocation) {
    assert(index >= 0);
    assert(index < _maxCandidateCount);
    return TownCandidate(String.fromCharCode(index + _capitalACharCode),
        _candidateHues[index], intLocation);
  }

  @override
  int compareTo(Candidate other) => id.compareTo(other.id);

  @override
  bool operator ==(Object other) => other is TownCandidate && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'TownCandidate($id)';
}

Point<int> fixPoint(Offset value) => Point(
      (value.dx / TownCandidate.candidateSpacing - 1).round(),
      (value.dy / TownCandidate.candidateSpacing - 1).round(),
    );

Point<double> _unfixPoint(Point<int> value) => Point(
      (value.x + 1) * TownCandidate.candidateSpacing,
      (value.y + 1) * TownCandidate.candidateSpacing,
    );

class TownVoter extends Voter {
  final Point<double> location;
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
