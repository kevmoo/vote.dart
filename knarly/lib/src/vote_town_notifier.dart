import 'dart:math' as math;

import 'package:flutter_web/material.dart';
import 'package:flutter_web_ui/ui.dart';

import 'model/town_candidate.dart';
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

    final candidateIndex = _value.candidates.indexOf(candidate);
    final originalCandidate = _value.candidates[candidateIndex];

    final originalFixedLocation = _fixPoint(originalCandidate.location);

    final newFixedLocation = _fixPoint(_workingPoint);

    if (newFixedLocation == originalFixedLocation) {
      // didn't move – skip!
      return;
    }

    if (newFixedLocation.x % 2 == 0 && newFixedLocation.y % 2 == 0) {
      // over a voter - skip!
      return;
    }

    print(newFixedLocation);

    final candidatesCopy = _value.candidates.toList(growable: false);
    candidatesCopy[candidateIndex] =
        TownCandidate(originalCandidate.index, _unfixPoint(newFixedLocation));

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

const _halfSpacing = VoteTown.voterSpacing / 2;

math.Point<int> _fixPoint(Point value) => math.Point(
      (value.x / _halfSpacing - 1).round(),
      (value.y / _halfSpacing - 1).round(),
    );

Point _unfixPoint(math.Point<int> value) => Point(
      (value.x + 1) * _halfSpacing,
      (value.y + 1) * _halfSpacing,
    );
