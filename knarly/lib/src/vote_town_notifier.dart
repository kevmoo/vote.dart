import 'package:flutter_web/material.dart';

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

  VoteTownNotifier(this._value);

  void moveCandidateStart(TownCandidate candidate) {
    assert(_value.candidates.contains(candidate));
    assert(_movingCandidate == null);
    _movingCandidate = candidate;
    notifyListeners();
  }

  void moveCandidateUpdate(TownCandidate candidate, Offset offset) {
    assert(candidate == _movingCandidate);
    assert(_value.candidates.contains(candidate));
    assert(offset.isFinite);

    if (offset.distanceSquared == 0) {
      // noop!
      return;
    }

    if (townSizeRatio == null) {
      print('oops? - null last size');
      return;
    }

    offset = offset * townSizeRatio;

    final candidateIndex = _value.candidates.indexOf(candidate);
    final originalCandidate = _value.candidates[candidateIndex];

    final newLocation = originalCandidate.location + offset;

    final candidatesCopy = _value.candidates.toList(growable: false);
    candidatesCopy[candidateIndex] =
        TownCandidate(originalCandidate.index, newLocation);

    _value = VoteTown(candidatesCopy);

    notifyListeners();
  }

  void moveCandidateEnd(TownCandidate candidate) {
    assert(candidate == _movingCandidate);
    _movingCandidate = null;
    notifyListeners();
  }
}
