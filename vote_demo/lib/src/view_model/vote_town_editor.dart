import 'dart:async';
import 'dart:math';
import 'dart:ui' show Offset;

import '../model/strategic_simulator.dart';
import '../model/town_folk.dart';
import '../model/vote_town.dart';
import 'editor.dart';

const _maxCandidates = 8;
const _simulationTick = Duration(milliseconds: 350);

class VoteTownEditor(super.value) extends KnarlyEditor<VoteTown> {
  final _locationMemory = <Point<int>>[];

  TownCandidate? get movingCandidate => _movingCandidate;
  TownCandidate? _movingCandidate;

  Offset? _workingPoint;

  TargetElectionMethod get targetMethod => _targetMethod;
  TargetElectionMethod _targetMethod = TargetElectionMethod.plurality;
  set targetMethod(TargetElectionMethod value) {
    if (_targetMethod == value) return;
    _targetMethod = value;
    _consecutiveNoMoveSteps = 0;
    notifyListeners();
  }

  SimulationMode get simulationMode => _simulationMode;
  SimulationMode _simulationMode = SimulationMode.selfish;
  set simulationMode(SimulationMode value) {
    if (_simulationMode == value) return;
    _simulationMode = value;
    _consecutiveNoMoveSteps = 0;
    notifyListeners();
  }

  int _nextCandidateIndex = 0;
  int get nextCandidateIndex => value.candidates.isEmpty
      ? 0
      : _nextCandidateIndex % value.candidates.length;

  TownCandidate? get nextCandidate =>
      value.candidates.isEmpty ? null : value.candidates[nextCandidateIndex];

  TownCandidate? get lastMovedCandidate => _lastMovedCandidate;
  TownCandidate? _lastMovedCandidate;

  Timer? _simulationTimer;
  int _consecutiveNoMoveSteps = 0;

  bool get isSimulating => _simulationTimer != null;

  bool isMole(TownCandidate candidate) =>
      _simulationMode.hasMole &&
      value.candidates.length >= 2 &&
      value.candidates.last == candidate;

  String? moleBadgeFor(TownCandidate candidate) {
    if (!isMole(candidate)) return null;
    return switch (_simulationMode) {
      SimulationMode.selfish => null,
      SimulationMode.moleHelpsA => '+A',
      SimulationMode.moleHurtsA => '−A',
    };
  }

  void toggleSimulation() {
    if (isSimulating) {
      pauseSimulation();
    } else {
      startSimulation();
    }
  }

  void startSimulation() {
    if (isSimulating || value.candidates.isEmpty) return;
    _consecutiveNoMoveSteps = 0;
    stepSimulation();
    _simulationTimer = Timer.periodic(_simulationTick, (_) {
      final result = stepSimulation();
      if (!result.moved) {
        _consecutiveNoMoveSteps++;
        if (_consecutiveNoMoveSteps >= value.candidates.length) {
          pauseSimulation();
        }
      } else {
        _consecutiveNoMoveSteps = 0;
      }
    });
    notifyListeners();
  }

  void pauseSimulation() {
    if (_simulationTimer == null) return;
    _simulationTimer?.cancel();
    _simulationTimer = null;
    notifyListeners();
  }

  SimulationStepResult stepSimulation() {
    final idx = nextCandidateIndex;
    final step = computeStrategicMove(
      value,
      candidateIndex: idx,
      method: _targetMethod,
      mode: _simulationMode,
    );
    _nextCandidateIndex = (idx + 1) % value.candidates.length;
    _lastMovedCandidate = step.candidate;
    if (step.moved) {
      setValue(step.town);
    } else {
      notifyListeners();
    }
    return step;
  }

  void scatterCandidates() {
    pauseSimulation();
    _nextCandidateIndex = 0;
    _lastMovedCandidate = null;
    _consecutiveNoMoveSteps = 0;
    setValue(
      VoteTown.random(
        candidateCount: value.candidates.length,
        centerFirstCandidate: false,
      ),
    );
  }

  void applyPreset(VoteTownPreset preset) {
    pauseSimulation();
    _nextCandidateIndex = 0;
    _lastMovedCandidate = null;
    _consecutiveNoMoveSteps = 0;
    setValue(preset.createTown());
  }

  void Function()? get addCandidate {
    final candidateCount = value.candidates.length;
    if (_movingCandidate != null || candidateCount >= _maxCandidates) {
      return null;
    }

    return () {
      pauseSimulation();
      _lastMovedCandidate = null;
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
      pauseSimulation();
      _lastMovedCandidate = null;
      while (_locationMemory.length < candidateCount) {
        _locationMemory.add(const Point(0, 0));
      }

      _locationMemory.setRange(
        0,
        candidateCount,
        value.candidates.take(candidateCount).map((e) => e.intLocation),
      );

      setValue(VoteTown(value.candidates.sublist(0, candidateCount - 1)));
      _nextCandidateIndex %= value.candidates.length;
    }

    return functionImpl;
  }

  void moveCandidateStart(TownCandidate candidate) {
    pauseSimulation();
    _lastMovedCandidate = null;
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
    candidatesCopy[candidateIndex] = TownCandidate(
      candidate.index,
      candidate.hue,
      newFixedLocation,
    );

    setValue(VoteTown(candidatesCopy));
  }

  void moveCandidateEnd(TownCandidate candidate) {
    assert(candidate == _movingCandidate);
    _movingCandidate = null;
    _workingPoint = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    super.dispose();
  }
}
