import 'package:flutter_web/material.dart';

import 'model/town_candidate.dart';
import 'model/vote_town.dart';

class VoteTownNotifier extends ChangeNotifier
    implements ValueListenable<VoteTown> {
  VoteTownNotifier(this._value);

  @override
  VoteTown get value => _value;
  VoteTown _value;

  /// A value we need to cache for dragging candidates.
  ///
  /// A bit weird to put it here, but I can't think of a better place.
  double townSizeCache;

  void move(TownCandidate candidate, Offset offset) {
    assert(_value.candidates.contains(candidate));
    assert(offset.isFinite);

    if (offset.distanceSquared == 0) {
      // noop!
      return;
    }

    final candidatesCopy = _value.candidates.toList(growable: false);

    final candidateIndex = candidatesCopy.indexOf(candidate);

    final originalCandidate = candidatesCopy[candidateIndex];

    candidatesCopy[candidateIndex] = TownCandidate(
        originalCandidate.index, originalCandidate.location + offset);

    _value = VoteTown(candidatesCopy);

    notifyListeners();
  }
}
