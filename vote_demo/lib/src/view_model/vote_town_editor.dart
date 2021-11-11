import 'dart:math';
import 'dart:ui' show Offset;

import '../model/town_folk.dart';
import '../model/vote_town.dart';
import 'editor.dart';

const _maxCandidates = 8;

class VoteTownEditor extends KnarlyEditor<VoteTown> {
  final _locationMemory = <Point<int>>[];

  TownCandidate? get movingCandidate => _movingCandidate;
  TownCandidate? _movingCandidate;

  Offset? _workingPoint;

  VoteTownEditor(VoteTown value) : super(value);

  void Function()? get addCandidate {
    final candidateCount = value.candidates.length;
    if (_movingCandidate != null || candidateCount >= _maxCandidates) {
      return null;
    }

    return () {
      setValue(
        value.copyPlusACandidate(
          tryLocation: _locationMemory.length > candidateCount
              ? _locationMemory[candidateCount]
              : null,
        ),
      );
    };
  }

  void Function()? get removeCandidate {
    final candidateCount = value.candidates.length;
    if (_movingCandidate != null || candidateCount <= 1) {
      return null;
    }

    void functionImpl() {
      while (_locationMemory.length < candidateCount) {
        _locationMemory.add(const Point(0, 0));
      }

      _locationMemory.setRange(
        0,
        candidateCount,
        value.candidates.take(candidateCount).map((e) => e.intLocation),
      );

      setValue(VoteTown(value.candidates.sublist(0, candidateCount - 1)));
    }

    return functionImpl;
  }

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

    assert(_workingPoint != null);
    _workingPoint = _workingPoint! + pixelOffset;
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
        TownCandidate(candidate.index, candidate.hue, newFixedLocation);

    setValue(VoteTown(candidatesCopy));
  }

  void moveCandidateEnd(TownCandidate candidate) {
    assert(candidate == _movingCandidate);
    _movingCandidate = null;
    _workingPoint = null;
    notifyListeners();
  }
}
