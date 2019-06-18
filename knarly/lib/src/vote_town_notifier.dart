import 'package:flutter_web/material.dart';

import 'model/town_candidate.dart';
import 'model/vote_town.dart';

class VoteTownNotifier extends ChangeNotifier
    implements ValueListenable<VoteTown> {
  VoteTownNotifier(this._value);

  @override
  VoteTown get value => _value;
  VoteTown _value;

  /// The scale from device pixels to the logical size of [VoteTown].
  double townSizeRatio;

  void moveCandidateUpdate(TownCandidate candidate, Offset offset) {
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

    final candidatesCopy = _value.candidates.toList(growable: false);

    final candidateIndex = candidatesCopy.indexOf(candidate);

    final originalCandidate = candidatesCopy[candidateIndex];

    candidatesCopy[candidateIndex] = TownCandidate(
        originalCandidate.index, originalCandidate.location + offset);

    _value = VoteTown(candidatesCopy);

    notifyListeners();
  }
}
