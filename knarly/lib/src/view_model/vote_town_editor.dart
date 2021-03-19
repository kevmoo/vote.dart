import 'dart:ui' show Offset;

import '../model/town_folk.dart';
import '../model/vote_town.dart';
import 'editor.dart';

class VoteTownEditor extends KnarlyEditor<VoteTown> {
  /// The scale from device pixels to the logical size of [VoteTown].
  double? townSizeRatio;

  TownCandidate? get movingCandidate => _movingCandidate;
  TownCandidate? _movingCandidate;

  Offset? _workingPoint;

  VoteTownEditor(VoteTown value) : super(value);

  void moveCandidateStart(TownCandidate candidate) {
    assert(value.candidates.contains(candidate));
    assert(_movingCandidate == null);
    assert(_workingPoint == null);
    _movingCandidate = candidate;
    _workingPoint = Offset(candidate.location.x, candidate.location.y);
    notifyListeners();
  }

  void moveCandidateUpdate(TownCandidate candidate, Offset pixelOffset) {
    assert(candidate == _movingCandidate);
    assert(value.candidates.contains(candidate));
    assert(pixelOffset.isFinite);

    if (townSizeRatio == null) {
      print('oops? - null last size');
      return;
    }

    assert(_workingPoint != null);
    _workingPoint = _workingPoint! + pixelOffset * townSizeRatio!;
    final newFixedLocation = fixPoint(_workingPoint!);

    if (newFixedLocation.x.isEven && newFixedLocation.y.isEven) {
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

    if (value.candidates.any((c) => c.intLocation == newFixedLocation)) {
      // don't overlap an existing candidate – skip!
      return;
    }

    final candidatesCopy = value.candidates.toList(growable: false);
    final candidateIndex = value.candidates.indexOf(candidate);
    candidatesCopy[candidateIndex] =
        TownCandidate(candidate.id, candidate.hue, newFixedLocation);

    setValue(VoteTown(candidatesCopy));

    notifyListeners();
  }

  void moveCandidateEnd(TownCandidate candidate) {
    assert(candidate == _movingCandidate);
    _movingCandidate = null;
    _workingPoint = null;
    notifyListeners();
  }
}
