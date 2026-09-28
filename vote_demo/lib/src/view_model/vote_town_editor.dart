import 'dart:async';
import 'dart:math';
import 'dart:ui' show Offset;

import '../model/strategic_simulator.dart';
import '../model/town_folk.dart';
import '../model/vote_town.dart';
import 'editor.dart';

const _maxCandidates = 8;
const _physicsFrameDuration = Duration(milliseconds: 16);
const _physicsDtSeconds = 0.016;

class VoteTownEditor(super.value) extends KnarlyEditor<VoteTown> {
  final _locationMemory = <Point<double>>[];

  var _velocities = <Point<double>>[];
  var _targets = <Point<double>>[];
  int _frameCounter = 0;
  int _settledFrames = 0;

  TownCandidate? get movingCandidate => _movingCandidate;
  TownCandidate? _movingCandidate;

  Offset? _workingPoint;

  TargetElectionMethod get targetMethod => _targetMethod;
  TargetElectionMethod _targetMethod = TargetElectionMethod.plurality;
  set targetMethod(TargetElectionMethod value) {
    if (_targetMethod == value) return;
    _targetMethod = value;
    _settledFrames = 0;
    if (isSimulating) {
      _refreshAllTargets();
    }
    notifyListeners();
  }

  SimulationMode get simulationMode => _simulationMode;
  SimulationMode _simulationMode = SimulationMode.selfish;
  set simulationMode(SimulationMode value) {
    if (_simulationMode == value) return;
    _simulationMode = value;
    _settledFrames = 0;
    if (isSimulating) {
      _refreshAllTargets();
    }
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
  bool _isContinuousPlay = false;

  bool get isSimulating => _simulationTimer != null && _isContinuousPlay;
  bool get isStepAnimating => _simulationTimer != null && !_isContinuousPlay;

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

  void _syncPhysicsState({bool resetVelocities = false}) {
    final candidates = value.candidates;
    if (resetVelocities || _velocities.length != candidates.length) {
      _velocities = List<Point<double>>.filled(
        candidates.length,
        const Point(0, 0),
      );
    }
    if (_targets.length != candidates.length) {
      _targets = [for (final c in candidates) c.location];
    }
  }

  void _refreshAllTargets() {
    _syncPhysicsState();
    for (var i = 0; i < value.candidates.length; i++) {
      _targets[i] = computeStrategicMove(
        value,
        candidateIndex: i,
        method: _targetMethod,
        mode: _simulationMode,
      ).toLocation;
    }
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
    _simulationTimer?.cancel();
    _isContinuousPlay = true;
    _frameCounter = 0;
    _settledFrames = 0;
    _lastMovedCandidate = null;
    _syncPhysicsState();
    _refreshAllTargets();

    _simulationTimer = Timer.periodic(_physicsFrameDuration, (_) {
      final count = value.candidates.length;
      if (count == 0) {
        pauseSimulation();
        return;
      }

      // Stagger lookahead target recalculation: 1 candidate refreshes its
      // desired target every 2 frames (~32ms) so all candidates continuously
      // adapt at 60fps with minimal CPU overhead.
      if (_frameCounter.isEven) {
        final idx = nextCandidateIndex;
        final step = computeStrategicMove(
          value,
          candidateIndex: idx,
          method: _targetMethod,
          mode: _simulationMode,
        );
        _targets[idx] = step.toLocation;
        _nextCandidateIndex = (idx + 1) % count;
      }
      _frameCounter++;

      final frame = advancePhysicsFrame(
        value,
        velocities: _velocities,
        targets: _targets,
        dtSeconds: _physicsDtSeconds,
      );
      _velocities = frame.velocities;

      if (frame.maxDisplacement > 0.03) {
        _settledFrames = 0;
        setValue(frame.town);
      } else {
        _settledFrames++;
        // Auto-pause once all candidates have settled into equilibrium for
        // ~1.2 seconds.
        if (_settledFrames >= 75) {
          pauseSimulation();
        }
      }
    });
    notifyListeners();
  }

  void pauseSimulation() {
    if (_simulationTimer == null) return;
    _simulationTimer?.cancel();
    _simulationTimer = null;
    _isContinuousPlay = false;
    notifyListeners();
  }

  /// Smoothly glides the next candidate toward its computed strategic target
  /// over ~280ms at 60fps.
  void animateSingleStep() {
    if (value.candidates.isEmpty) return;
    pauseSimulation();
    _syncPhysicsState(resetVelocities: true);

    final idx = nextCandidateIndex;
    final step = computeStrategicMove(
      value,
      candidateIndex: idx,
      method: _targetMethod,
      mode: _simulationMode,
    );
    _nextCandidateIndex = (idx + 1) % value.candidates.length;
    _lastMovedCandidate = step.candidate;

    if (!step.moved) {
      notifyListeners();
      return;
    }

    _targets = [for (final c in value.candidates) c.location];
    _targets[idx] = step.toLocation;
    _isContinuousPlay = false;

    var framesRemaining = 20;
    _simulationTimer = Timer.periodic(_physicsFrameDuration, (_) {
      framesRemaining--;
      final frame = advancePhysicsFrame(
        value,
        velocities: _velocities,
        targets: _targets,
        dtSeconds: _physicsDtSeconds,
        onlyCandidateIndex: idx,
        maxSpeed: 95.0,
      );
      _velocities = frame.velocities;
      setValue(frame.town);

      final distLeft = frame.town.candidates[idx].location.distanceTo(
        step.toLocation,
      );
      if (framesRemaining <= 0 || distLeft < 0.35) {
        pauseSimulation();
      }
    });
    notifyListeners();
  }

  /// Synchronously executes one candidate's strategic move (used by tests and
  /// deterministic stepping).
  SimulationStepResult stepSimulation() {
    pauseSimulation();
    final idx = nextCandidateIndex;
    final step = computeStrategicMove(
      value,
      candidateIndex: idx,
      method: _targetMethod,
      mode: _simulationMode,
    );
    _nextCandidateIndex = (idx + 1) % value.candidates.length;
    _lastMovedCandidate = step.candidate;
    _syncPhysicsState(resetVelocities: true);
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
    _settledFrames = 0;
    setValue(
      VoteTown.random(
        candidateCount: value.candidates.length,
        centerFirstCandidate: false,
      ),
    );
    _syncPhysicsState(resetVelocities: true);
  }

  void applyPreset(VoteTownPreset preset) {
    pauseSimulation();
    _nextCandidateIndex = 0;
    _lastMovedCandidate = null;
    _settledFrames = 0;
    setValue(preset.createTown());
    _syncPhysicsState(resetVelocities: true);
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
      _syncPhysicsState(resetVelocities: true);
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
        value.candidates.take(candidateCount).map((e) => e.location),
      );

      setValue(VoteTown(value.candidates.sublist(0, candidateCount - 1)));
      _nextCandidateIndex %= value.candidates.length;
      _syncPhysicsState(resetVelocities: true);
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

    final candidateIndex = value.candidates.indexOf(candidate);
    final resolvedLocation = resolveSingleCandidatePosition(
      value.candidates,
      candidateIndex,
      Point<double>(_workingPoint!.dx, _workingPoint!.dy),
    );

    final candidatesCopy = value.candidates.toList(growable: false);
    candidatesCopy[candidateIndex] = candidate.withLocation(resolvedLocation);

    setValue(VoteTown(candidatesCopy));
    _syncPhysicsState(resetVelocities: true);
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
