import 'package:flutter_web/material.dart';
import 'package:flutter_web_ui/ui.dart';

import 'model/town_folk.dart';
import 'model/vote_town.dart';

class VoteTownNotifier extends ChangeNotifier
    implements ValueListenable<VoteTown> {
  @override
  VoteTown get value => _value;
  VoteTown _value;

  /// The scale from device pixels to the logical size of [VoteTown].
  double townSizeRatio;

  TownCandidate get movingCandidate => _movingCandidate;
  TownCandidate _movingCandidate;

  Point _workingPoint;

  VoteTownNotifier(this._value);

  void moveCandidateStart(TownCandidate candidate) {
    assert(_value.candidates.contains(candidate));
    assert(_movingCandidate == null);
    assert(_workingPoint == null);
    _movingCandidate = candidate;
    _workingPoint = candidate.location;
    notifyListeners();
  }

  void moveCandidateUpdate(TownCandidate candidate, Offset pixelOffset) {
    assert(candidate == _movingCandidate);
    assert(_value.candidates.contains(candidate));
    assert(pixelOffset.isFinite);

    if (townSizeRatio == null) {
      print('oops? - null last size');
      return;
    }

    assert(_workingPoint != null);
    _workingPoint += pixelOffset * townSizeRatio;
    final newFixedLocation = fixPoint(_workingPoint);

    if (newFixedLocation.x % 2 == 0 && newFixedLocation.y % 2 == 0) {
      // over a voter - skip!
      return;
    }

    const candidateLocationUpper = VoteTown.votersAcross * 2 - 1;

    if (newFixedLocation.x < 0 ||
        newFixedLocation.y < 0 ||
        newFixedLocation.x >= candidateLocationUpper ||
        newFixedLocation.y >= candidateLocationUpper) {
      // off the edge – skip!
      return;
    }

    if (_value.candidates.any((c) => c.intLocation == newFixedLocation)) {
      // don't overlap an existing candidate – skip!
      return;
    }

    final candidatesCopy = _value.candidates.toList(growable: false);
    final candidateIndex = _value.candidates.indexOf(candidate);
    candidatesCopy[candidateIndex] =
        TownCandidate(candidate.id, candidate.hue, newFixedLocation);

    _value = VoteTown(candidatesCopy);

    notifyListeners();
  }

  void moveCandidateEnd(TownCandidate candidate) {
    assert(candidate == _movingCandidate);
    _movingCandidate = null;
    _workingPoint = null;
    notifyListeners();
  }
}
