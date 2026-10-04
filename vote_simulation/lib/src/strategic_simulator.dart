import 'dart:math';

import 'package:collection/collection.dart';

import 'candidate.dart';
import 'town_folk.dart';
import 'vote_town.dart';

enum TargetElectionMethod(final String label) {
  plurality('Plurality'),
  irv('IRV'),
  condorcet('Condorcet'),
}

enum SimulationMode(final String label, final String shortDescription) {
  selfish('All Selfish', 'Every candidate moves to improve its own result.'),
  moleHelpsA('Mole Helps A', 'Last candidate is a Mole trying to help A win.'),
  moleHurtsA('Mole Hurts A', 'Last candidate is a Mole trying to make A lose.');

  bool get hasMole => this != SimulationMode.selfish;
}

enum VoteTownPreset(final String label, final String description) {
  twoCandidates(
    '2 Candidates',
    'With only 2 candidates, Plurality, Condorcet, and IRV always agree.',
  ),
  pluralitySpoiler(
    '3rd Spoils Plurality',
    'Candidate C splits the majority side of town with A, handing Plurality '
        'to B even though a majority prefers A over B.',
  ),
  irvCenterSqueeze(
    'Center Squeeze (IRV)',
    'Candidate A sits at the ideal center (0.00), but surrounding candidates '
        'squeeze A out in Plurality and IRV while Condorcet still elects A.',
  );

  VoteTown createTown() => switch (this) {
    VoteTownPreset.twoCandidates => VoteTown.fromLocations(const [
      Point(58, 75),
      Point(115, 75),
    ]),
    VoteTownPreset.pluralitySpoiler => VoteTown.fromLocations(const [
      Point(58, 75),
      Point(115, 75),
      Point(28, 48),
    ]),
    VoteTownPreset.irvCenterSqueeze => VoteTown.fromLocations(const [
      Point(75, 75),
      Point(50, 75),
      Point(100, 72),
    ]),
  };
}

class const SimulationStepResult({
  required final VoteTown town,
  required final TownCandidate candidate,
  required final Point<double> fromLocation,
  required final Point<double> toLocation,
  required final bool isMole,
}) {
  bool get moved => fromLocation.distanceTo(toLocation) > 0.25;
}

class const PhysicsFrameResult({
  required final VoteTown town,
  required final List<Point<double>> velocities,
  required final double maxDisplacement,
});

class const PluralitySpoilerInfo({
  required final Candidate pluralityWinner,
  required final int pluralityWinnerVotes,
  required final Candidate condorcetWinner,
  required final int condorcetOverPluralityVotes,
  required final int pluralityOverCondorcetVotes,
  required final Candidate? spoilerCandidate,
});

/// Detects when a Plurality election has been spoiled: i.e. there is a single
/// Condorcet winner ($W_C$) who beats every other candidate 1-on-1, yet a
/// different candidate ($W_P$) wins (or ties for 1st in) Plurality because
/// vote-splitting divided $W_C$'s support.
PluralitySpoilerInfo? detectPluralitySpoiler(VoteTown town) {
  if (town.candidates.length <= 2) {
    return null;
  }

  final condorcetTop = town.condorcetElection.places.first;
  if (condorcetTop.length != 1) {
    return null;
  }
  final condorcetWinner = condorcetTop.single;

  final pluralityTop = town.pluralityElection.places.first;
  if (pluralityTop.length == 1 && pluralityTop.single == condorcetWinner) {
    return null;
  }

  final pluralityWinner = pluralityTop.firstWhere(
    (c) => c != condorcetWinner,
    orElse: () => pluralityTop.first,
  );

  final pair = town.condorcetElection.getPair(condorcetWinner, pluralityWinner);

  // Identify if removing a single losing candidate would restore
  // condorcetWinner as the sole Plurality winner.
  TownCandidate? spoiler;
  for (final candidate in town.candidates) {
    if (candidate == condorcetWinner || candidate == pluralityWinner) {
      continue;
    }
    final reducedTown = VoteTown(
      town.candidates.where((c) => c != candidate).toList(growable: false),
    );
    final reducedTop = reducedTown.pluralityElection.places.first;
    if (reducedTop.length == 1 && reducedTop.single == condorcetWinner) {
      spoiler = candidate;
      break;
    }
  }

  return PluralitySpoilerInfo(
    pluralityWinner: pluralityWinner,
    pluralityWinnerVotes: pluralityTop.voteCount,
    condorcetWinner: condorcetWinner,
    condorcetOverPluralityVotes: pair.firstOverSecond ?? 0,
    pluralityOverCondorcetVotes: pair.secondOverFirst ?? 0,
    spoilerCandidate: spoiler,
  );
}

/// Computes a continuous desired target move for the candidate at
/// [candidateIndex] within [maxStepDistance] town units.
SimulationStepResult computeStrategicMove(
  VoteTown town, {
  required int candidateIndex,
  required TargetElectionMethod method,
  required SimulationMode mode,
  double maxStepDistance = 28.0,
}) {
  RangeError.checkValidIndex(candidateIndex, town.candidates);

  final movingCandidate = town.candidates[candidateIndex];
  final startPoint = movingCandidate.location;
  final isMole =
      mode.hasMole &&
      town.candidates.length >= 2 &&
      candidateIndex == town.candidates.length - 1;
  final effectiveMaxStep = isMole ? maxStepDistance * 1.35 : maxStepDistance;

  final otherLocations = [
    for (var i = 0; i < town.candidates.length; i++)
      if (i != candidateIndex) town.candidates[i].location,
  ];

  bool isLegalPoint(Point<double> p) => otherLocations.every(
    (other) => other.distanceTo(p) >= TownCandidate.repulsionRadius,
  );

  final candidatePoints = _collectCandidateSamplePoints(
    startPoint: startPoint,
    effectiveMaxStep: effectiveMaxStep,
    isMole: isMole,
    otherLocations: otherLocations,
    isLegalPoint: isLegalPoint,
  );

  final bestGlobalPoint = _selectBestTargetPoint(
    town,
    candidatePoints: candidatePoints,
    candidateIndex: candidateIndex,
    isMole: isMole,
    method: method,
    mode: mode,
  );

  final stepPoint = _computeBoundedStepPoint(
    town,
    startPoint: startPoint,
    bestGlobalPoint: bestGlobalPoint,
    effectiveMaxStep: effectiveMaxStep,
    isMole: isMole,
    mode: mode,
    candidatePoints: candidatePoints,
    isLegalPoint: isLegalPoint,
  );

  final finalCandidates = town.candidates.toList(growable: false);
  finalCandidates[candidateIndex] = movingCandidate.withLocation(stepPoint);
  final finalTown = VoteTown(finalCandidates);

  return SimulationStepResult(
    town: finalTown,
    candidate: finalTown.candidates[candidateIndex],
    fromLocation: startPoint,
    toLocation: stepPoint,
    isMole: isMole,
  );
}

List<Point<double>> _collectCandidateSamplePoints({
  required Point<double> startPoint,
  required double effectiveMaxStep,
  required bool isMole,
  required List<Point<double>> otherLocations,
  required bool Function(Point<double>) isLegalPoint,
}) {
  final candidatePoints = <Point<double>>[];

  void tryAddPoint(Point<double> rawPoint) {
    final clamped = VoteTown.clampToBounds(rawPoint);
    if (isLegalPoint(clamped)) {
      candidatePoints.add(clamped);
    }
  }

  tryAddPoint(startPoint);
  final toCenter = VoteTown.center - startPoint;
  final centerProbe = toCenter.magnitude <= effectiveMaxStep
      ? VoteTown.center
      : startPoint + toCenter * (effectiveMaxStep / toCenter.magnitude);
  tryAddPoint(centerProbe);

  _addRadialRingSamples(startPoint, effectiveMaxStep, tryAddPoint);
  if (isMole) {
    _addMoleGlobalSamples(otherLocations, tryAddPoint);
  } else {
    _addSelfishCenterSamples(startPoint, effectiveMaxStep, tryAddPoint);
  }
  return candidatePoints;
}

void _addRadialRingSamples(
  Point<double> center,
  double maxRadius,
  void Function(Point<double>) tryAddPoint,
) {
  const ringFractions = [0.15, 0.35, 0.65, 1.0];
  for (final fraction in ringFractions) {
    _addCircleSamples(center, maxRadius * fraction, 16, tryAddPoint);
  }
}

void _addCircleSamples(
  Point<double> center,
  double radius,
  int directions,
  void Function(Point<double>) onPoint,
) {
  for (var d = 0; d < directions; d++) {
    final angle = (2 * pi * d) / directions;
    onPoint(
      Point<double>(
        center.x + cos(angle) * radius,
        center.y + sin(angle) * radius,
      ),
    );
  }
}

void _addMoleGlobalSamples(
  List<Point<double>> otherLocations,
  void Function(Point<double>) tryAddPoint,
) {
  const radii = [
    TownCandidate.repulsionRadius + 0.5,
    TownCandidate.repulsionRadius + 10.0,
  ];
  for (final landmark in [VoteTown.center, ...otherLocations]) {
    for (final radius in radii) {
      _addCircleSamples(landmark, radius, 16, tryAddPoint);
    }
  }
  for (var y = 15.0; y <= 135.0; y += 20.0) {
    for (var x = 15.0; x <= 135.0; x += 20.0) {
      tryAddPoint(Point<double>(x, y));
    }
  }
}

void _addSelfishCenterSamples(
  Point<double> startPoint,
  double effectiveMaxStep,
  void Function(Point<double>) tryAddPoint,
) {
  _addCircleSamples(VoteTown.center, TownCandidate.repulsionRadius + 0.5, 16, (
    p,
  ) {
    if (startPoint.distanceTo(p) <= effectiveMaxStep) {
      tryAddPoint(p);
    }
  });
}

Point<double> _selectBestTargetPoint(
  VoteTown town, {
  required List<Point<double>> candidatePoints,
  required int candidateIndex,
  required bool isMole,
  required TargetElectionMethod method,
  required SimulationMode mode,
}) {
  final movingCandidate = town.candidates[candidateIndex];
  var bestGlobalPoint = movingCandidate.location;
  var bestScore = _evaluateTownForMove(
    town,
    movingCandidateIndex: candidateIndex,
    isMole: isMole,
    method: method,
    mode: mode,
  );

  for (final candidatePoint in candidatePoints) {
    final updatedCandidates = town.candidates.toList(growable: false);
    updatedCandidates[candidateIndex] = movingCandidate.withLocation(
      candidatePoint,
    );
    final trialScore = _evaluateTownForMove(
      VoteTown(updatedCandidates),
      movingCandidateIndex: candidateIndex,
      isMole: isMole,
      method: method,
      mode: mode,
    );

    if (trialScore.compareTo(bestScore) > 0) {
      bestScore = trialScore;
      bestGlobalPoint = candidatePoint;
    }
  }
  return bestGlobalPoint;
}

Point<double> _computeBoundedStepPoint(
  VoteTown town, {
  required Point<double> startPoint,
  required Point<double> bestGlobalPoint,
  required double effectiveMaxStep,
  required bool isMole,
  required SimulationMode mode,
  required List<Point<double>> candidatePoints,
  required bool Function(Point<double>) isLegalPoint,
}) {
  final distToBest = startPoint.distanceTo(bestGlobalPoint);
  if (distToBest <= effectiveMaxStep) {
    return bestGlobalPoint;
  }

  final dir = (bestGlobalPoint - startPoint) * (1.0 / distToBest);
  var rawStep = startPoint + dir * effectiveMaxStep;
  if (isMole && mode == SimulationMode.moleHelpsA) {
    rawStep = _deflectStepAroundTargetA(
      startPoint: startPoint,
      rawStep: rawStep,
      targetA: town.candidates.first.location,
      effectiveMaxStep: effectiveMaxStep,
    );
  }
  if (isLegalPoint(rawStep)) {
    return VoteTown.clampToBounds(rawStep);
  }
  return _closestReachablePoint(
    startPoint: startPoint,
    bestGlobalPoint: bestGlobalPoint,
    effectiveMaxStep: effectiveMaxStep,
    candidatePoints: candidatePoints,
  );
}

Point<double> _deflectStepAroundTargetA({
  required Point<double> startPoint,
  required Point<double> rawStep,
  required Point<double> targetA,
  required double effectiveMaxStep,
}) {
  if (rawStep.distanceTo(targetA) >= TownCandidate.repulsionRadius + 10.0) {
    return rawStep;
  }
  final awayFromA = rawStep - targetA;
  final awayDist = awayFromA.magnitude;
  if (awayDist <= 1e-4) {
    return rawStep;
  }
  final deflected =
      targetA + awayFromA * ((TownCandidate.repulsionRadius + 12.0) / awayDist);
  final defDelta = deflected - startPoint;
  if (defDelta.magnitude <= 1e-4) {
    return rawStep;
  }
  return startPoint + defDelta * (effectiveMaxStep / defDelta.magnitude);
}

Point<double> _closestReachablePoint({
  required Point<double> startPoint,
  required Point<double> bestGlobalPoint,
  required double effectiveMaxStep,
  required List<Point<double>> candidatePoints,
}) {
  var bestStep = bestGlobalPoint;
  var minRemainingDist = double.infinity;
  for (final p in candidatePoints) {
    if (startPoint.distanceTo(p) <= effectiveMaxStep + 1e-5) {
      final rem = p.distanceTo(bestGlobalPoint);
      if (rem < minRemainingDist) {
        minRemainingDist = rem;
        bestStep = p;
      }
    }
  }
  return bestStep;
}

/// Projects [desired] for the candidate at [movingIndex] so it remains within
/// board bounds and at least [TownCandidate.minSeparation] away from all other
/// candidates.
Point<double> resolveSingleCandidatePosition(
  List<TownCandidate> candidates,
  int movingIndex,
  Point<double> desired,
) {
  var pos = VoteTown.clampToBounds(desired);
  for (var pass = 0; pass < 3; pass++) {
    for (var i = 0; i < candidates.length; i++) {
      if (i == movingIndex) continue;
      final other = candidates[i].location;
      final diff = pos - other;
      final dist = diff.magnitude;
      if (dist < TownCandidate.minSeparation) {
        final unit = dist > 1e-4
            ? diff * (1.0 / dist)
            : Point<double>(cos(movingIndex + i), sin(movingIndex + i));
        pos = VoteTown.clampToBounds(
          other + unit * TownCandidate.minSeparation,
        );
      }
    }
  }
  return pos;
}

/// Advances continuous candidate positions and velocities by [dtSeconds] with
/// target seeking, arrival damping, momentum, and steeply ramping candidate
/// repulsion.
PhysicsFrameResult advancePhysicsFrame(
  VoteTown town, {
  required List<Point<double>> velocities,
  required List<Point<double>> targets,
  required double dtSeconds,
  SimulationMode mode = SimulationMode.selfish,
  int? onlyCandidateIndex,
  double maxSpeed = 52.0,
}) {
  final dt = dtSeconds.clamp(0.001, 0.05);
  final count = town.candidates.length;
  final positions = [for (final c in town.candidates) c.location];
  final nextVelocities = List<Point<double>>.of(velocities);
  final steerBlend = 1.0 - exp(-dt * 9.0);

  for (var i = 0; i < count; i++) {
    if (onlyCandidateIndex != null && i != onlyCandidateIndex) {
      nextVelocities[i] = const Point(0, 0);
      continue;
    }

    final isMole = mode.hasMole && count >= 2 && i == count - 1;
    final candidateMaxSpeed = isMole ? maxSpeed * 1.35 : maxSpeed;
    final vel = _stepCandidateVelocity(
      index: i,
      positions: positions,
      currentVelocity: velocities[i],
      target: targets[i],
      candidateMaxSpeed: candidateMaxSpeed,
      steerBlend: steerBlend,
    );
    nextVelocities[i] = vel;
    positions[i] = VoteTown.clampToBounds(positions[i] + vel * dt);
  }

  _enforcePairwiseMinSeparation(
    positions: positions,
    velocities: nextVelocities,
    onlyCandidateIndex: onlyCandidateIndex,
  );

  var maxDisplacement = 0.0;
  final updatedCandidates = <TownCandidate>[];
  for (var i = 0; i < count; i++) {
    final disp = positions[i].distanceTo(town.candidates[i].location);
    if (disp > maxDisplacement) {
      maxDisplacement = disp;
    }
    updatedCandidates.add(town.candidates[i].withLocation(positions[i]));
  }

  return PhysicsFrameResult(
    town: VoteTown(updatedCandidates),
    velocities: nextVelocities,
    maxDisplacement: maxDisplacement,
  );
}

Point<double> _stepCandidateVelocity({
  required int index,
  required List<Point<double>> positions,
  required Point<double> currentVelocity,
  required Point<double> target,
  required double candidateMaxSpeed,
  required double steerBlend,
}) {
  const arrivalRadius = 8.0;
  final pos = positions[index];
  final toTarget = target - pos;
  final distToTarget = toTarget.magnitude;

  var desiredVel = const Point<double>(0, 0);
  if (distToTarget > 0.15) {
    final speed = distToTarget < arrivalRadius
        ? candidateMaxSpeed * (distToTarget / arrivalRadius)
        : candidateMaxSpeed;
    desiredVel = toTarget * (speed / distToTarget);
  }

  final mobilityFactor = (distToTarget / 5.0).clamp(0.0, 1.0);
  final (deflectedDesired, repelVel) = mobilityFactor > 0.01
      ? _computeRepulsionAndDeflection(
          index: index,
          positions: positions,
          desiredVel: desiredVel,
          candidateMaxSpeed: candidateMaxSpeed,
          mobilityFactor: mobilityFactor,
        )
      : (desiredVel, const Point<double>(0, 0));

  final combinedDesired = deflectedDesired + repelVel;
  var vel = currentVelocity + (combinedDesired - currentVelocity) * steerBlend;
  if (distToTarget < 0.8 && repelVel.magnitude < 0.5) {
    vel *= 0.5;
  }
  final speed = vel.magnitude;
  if (speed > candidateMaxSpeed * 1.4) {
    vel = vel * ((candidateMaxSpeed * 1.4) / speed);
  }
  return vel;
}

(Point<double> desiredVel, Point<double> repelVel)
_computeRepulsionAndDeflection({
  required int index,
  required List<Point<double>> positions,
  required Point<double> desiredVel,
  required double candidateMaxSpeed,
  required double mobilityFactor,
}) {
  const repulsionRadius = TownCandidate.repulsionRadius;
  const repulsionSpan = repulsionRadius - TownCandidate.minSeparation;
  final pos = positions[index];
  var nextDesired = desiredVel;
  var repelVel = const Point<double>(0, 0);

  for (var j = 0; j < positions.length; j++) {
    if (index == j) continue;
    final away = pos - positions[j];
    final dist = away.magnitude;
    if (dist >= repulsionRadius + 3.0 || dist <= 1e-4) continue;

    final awayUnit = away * (1.0 / dist);
    if (dist < repulsionRadius) {
      final u = ((repulsionRadius - dist) / repulsionSpan).clamp(0.0, 2.0);
      final u2 = u * u;
      final strength =
          (0.35 * u + 3.0 * u2 * u2) * candidateMaxSpeed * mobilityFactor;
      repelVel += awayUnit * strength;
    }

    final inwardDot = nextDesired.x * awayUnit.x + nextDesired.y * awayUnit.y;
    if (inwardDot < 0) {
      final block = ((repulsionRadius + 3.0 - dist) / 5.0).clamp(0.0, 1.0);
      nextDesired -= awayUnit * (inwardDot * block);
    }
  }
  return (nextDesired, repelVel);
}

void _enforcePairwiseMinSeparation({
  required List<Point<double>> positions,
  required List<Point<double>> velocities,
  required int? onlyCandidateIndex,
}) {
  final count = positions.length;
  for (var pass = 0; pass < 4; pass++) {
    for (var i = 0; i < count; i++) {
      for (var j = i + 1; j < count; j++) {
        _separateCandidatePair(
          positions: positions,
          velocities: velocities,
          i: i,
          j: j,
          onlyCandidateIndex: onlyCandidateIndex,
        );
      }
    }
  }
}

void _separateCandidatePair({
  required List<Point<double>> positions,
  required List<Point<double>> velocities,
  required int i,
  required int j,
  required int? onlyCandidateIndex,
}) {
  const minSep = TownCandidate.minSeparation;
  final diff = positions[i] - positions[j];
  final dist = diff.magnitude;
  if (dist >= minSep) return;

  final overlap = minSep - dist;
  final unit = dist > 1e-4
      ? diff * (1.0 / dist)
      : Point<double>(cos(i + j), sin(i + j));
  final weightI = _separationWeightForFirst(
    velocities[i].magnitude,
    velocities[j].magnitude,
    i: i,
    j: j,
    onlyCandidateIndex: onlyCandidateIndex,
  );
  final weightJ = 1.0 - weightI;

  positions[i] = VoteTown.clampToBounds(
    positions[i] + unit * (overlap * weightI),
  );
  positions[j] = VoteTown.clampToBounds(
    positions[j] - unit * (overlap * weightJ),
  );
}

double _separationWeightForFirst(
  double speedI,
  double speedJ, {
  required int i,
  required int j,
  required int? onlyCandidateIndex,
}) {
  if (onlyCandidateIndex == i) return 1.0;
  if (onlyCandidateIndex == j) return 0.0;
  final totalSpeed = speedI + speedJ;
  return totalSpeed > 1e-3 ? speedI / totalSpeed : 0.5;
}

_MoveScore _evaluateTownForMove(
  VoteTown town, {
  required int movingCandidateIndex,
  required bool isMole,
  required TargetElectionMethod method,
  required SimulationMode mode,
}) {
  final movingCandidate = town.candidates[movingCandidateIndex];

  if (!isMole) {
    final standing = _evaluateStanding(
      town,
      movingCandidate,
      method,
      forSelfishMover: true,
    );
    // Tie-break by moving closer to the geometric center of town.
    final centerBonus = -averageVoterDistanceTo(town, movingCandidate.location);
    return _MoveScore(standing, centerBonus);
  }

  final targetA = town.candidates.first;
  final rivals = town.candidates
      .where((c) => c != targetA && c != movingCandidate)
      .toList(growable: false);

  // Measure how many first-choice voters the Mole steals from A compared to
  // the election without the Mole, and how many votes the top rival has.
  final townWithoutMole = VoteTown([targetA, ...rivals]);
  final aVotesWithoutMole = townWithoutMole.pluralityElection.places
      .firstWhere((p) => p.contains(targetA))
      .voteCount;
  final aVotesWithMole = town.pluralityElection.places
      .firstWhere((p) => p.contains(targetA))
      .voteCount;
  final stolenFromA = aVotesWithoutMole - aVotesWithMole;

  var maxRivalVotesWithMole = 0;
  for (final r in rivals) {
    final v = town.pluralityElection.places
        .firstWhere((p) => p.contains(r))
        .voteCount;
    if (v > maxRivalVotesWithMole) {
      maxRivalVotesWithMole = v;
    }
  }

  final standingA = _evaluateStanding(
    town,
    targetA,
    method,
    forSelfishMover: false,
    moleCandidate: movingCandidate,
    mode: mode,
  );
  final standingMole = _evaluateStanding(
    town,
    movingCandidate,
    method,
    forSelfishMover: false,
  );

  if (mode == SimulationMode.moleHelpsA) {
    // A Kingmaker Mole (+A) wants A to win, must not win the election itself,
    // and wants to maximize A's margin over real rivals while not stealing A's
    // own voters.
    final moleWinsElection = standingMole.metrics.first;
    final aMarginOverRivals = aVotesWithMole - maxRivalVotesWithMole;

    var tieBreak = 0.0;
    if (rivals.isNotEmpty) {
      final topRival = maxBy(
        rivals,
        (r) => _evaluateStanding(town, r, method, forSelfishMover: false),
      )!;
      tieBreak = -movingCandidate.location.distanceTo(topRival.location);
    }
    return _MoveScore(
      _CandidateStanding([
        standingA.metrics.first, // 1 if A is sole winner of target method
        -moleWinsElection, // 0 if Mole doesn't win, -1 if Mole wins itself
        aMarginOverRivals,
        ...standingA.metrics.skip(1),
        -stolenFromA,
      ]),
      tieBreak,
    );
  } else {
    assert(mode == SimulationMode.moleHurtsA);
    // Saboteur Mole (−A) wants A to lose (preferably to a real rival).
    final tieBreak = -movingCandidate.location.distanceTo(targetA.location);
    final negatedMetrics = [for (final m in standingA.metrics) -m];
    final rivalMarginOverA = maxRivalVotesWithMole - aVotesWithMole;
    return _MoveScore(
      _CandidateStanding([
        negatedMetrics
            .first, // 0 if A is not sole winner, -1 if A is sole winner
        rivalMarginOverA,
        stolenFromA,
        ...negatedMetrics.skip(1),
      ]),
      tieBreak,
    );
  }
}

_CandidateStanding _evaluateStanding(
  VoteTown town,
  TownCandidate target,
  TargetElectionMethod method, {
  required bool forSelfishMover,
  TownCandidate? moleCandidate,
  SimulationMode? mode,
}) => switch (method) {
  TargetElectionMethod.plurality => _evaluatePlurality(
    town,
    target,
    forSelfishMover: forSelfishMover,
  ),
  TargetElectionMethod.condorcet => _evaluateCondorcet(
    town,
    target,
    forSelfishMover: forSelfishMover,
    moleCandidate: moleCandidate,
    mode: mode,
  ),
  TargetElectionMethod.irv => _evaluateIrv(
    town,
    target,
    forSelfishMover: forSelfishMover,
  ),
};

_CandidateStanding _evaluatePlurality(
  VoteTown town,
  TownCandidate target, {
  required bool forSelfishMover,
}) {
  final election = town.pluralityElection;
  final myPlace = election.places.firstWhere((p) => p.contains(target));
  final myVotes = myPlace.voteCount;

  var maxOtherVotes = 0;
  for (final place in election.places) {
    for (final candidate in place) {
      if (candidate != target && place.voteCount > maxOtherVotes) {
        maxOtherVotes = place.voteCount;
      }
    }
  }

  final margin = myVotes - maxOtherVotes;
  final isSoleWinner = myPlace.place == 1 && myPlace.length == 1;
  if (forSelfishMover && isSoleWinner && margin >= 10) {
    // Already winning Plurality with a safe cushion; prefer staying/moving
    // closer to the center of town rather than chasing grid-tilt margins.
    return const _CandidateStanding([1, 1000]);
  }
  return _CandidateStanding([isSoleWinner ? 1 : 0, margin, myVotes]);
}

_CandidateStanding _evaluateCondorcet(
  VoteTown town,
  TownCandidate target, {
  required bool forSelfishMover,
  TownCandidate? moleCandidate,
  SimulationMode? mode,
}) {
  final election = town.condorcetElection;
  final myPlace = election.places.firstWhere((p) => p.contains(target));
  final (pairwiseWins, minimaxMargin, totalMargin) = _condorcetPairwiseStats(
    town,
    target,
    moleCandidate: moleCandidate,
    mode: mode,
  );

  final isSoleWinner =
      myPlace.place == 1 &&
      myPlace.length == 1 &&
      pairwiseWins == town.candidates.length - 1;

  if (forSelfishMover && isSoleWinner && minimaxMargin >= 8) {
    // Sole Condorcet winner with a solid pairwise margin: prefer closeness to
    // the median voter (center) over chasing off-center opponents.
    return const _CandidateStanding([1, 1000]);
  }

  return _CandidateStanding([
    isSoleWinner ? 1 : 0,
    minimaxMargin,
    pairwiseWins,
    totalMargin,
  ]);
}

(int pairwiseWins, int minimaxMargin, int totalMargin) _condorcetPairwiseStats(
  VoteTown town,
  TownCandidate target, {
  TownCandidate? moleCandidate,
  SimulationMode? mode,
}) {
  final election = town.condorcetElection;
  var pairwiseWins = 0;
  var minimaxMargin = 1000;
  var totalMargin = 0;

  for (final other in town.candidates) {
    if (other == target) continue;
    final pair = election.getPair(target, other);
    final diff = (pair.firstOverSecond ?? 0) - (pair.secondOverFirst ?? 0);
    if (diff > 0) {
      pairwiseWins++;
    }
    if (mode == SimulationMode.moleHelpsA &&
        other == moleCandidate &&
        diff > 0) {
      continue;
    }
    if (diff < minimaxMargin) {
      minimaxMargin = diff;
    }
    totalMargin += diff;
  }

  return (pairwiseWins, minimaxMargin == 1000 ? 0 : minimaxMargin, totalMargin);
}

_CandidateStanding _evaluateIrv(
  VoteTown town,
  TownCandidate target, {
  required bool forSelfishMover,
}) {
  final election = town.irvElection;
  final myOverallPlace = election.places.firstWhere((p) => p.contains(target));

  final round1Place = election.rounds.first.places.firstWhereOrNull(
    (p) => p.contains(target),
  );
  final round1Votes = round1Place?.voteCount ?? 0;

  final isSoleWinner = myOverallPlace.place == 1 && myOverallPlace.length == 1;
  if (isSoleWinner) {
    return _evaluateIrvWinnerStanding(
      town,
      target,
      round1Votes: round1Votes,
      forSelfishMover: forSelfishMover,
    );
  }
  return _evaluateIrvLoserStanding(
    town,
    target,
    overallPlace: myOverallPlace.place,
    round1Votes: round1Votes,
  );
}

_CandidateStanding _evaluateIrvWinnerStanding(
  VoteTown town,
  TownCandidate target, {
  required int round1Votes,
  required bool forSelfishMover,
}) {
  final rounds = town.irvElection.rounds;
  var minMargin = 1000;
  var finalMargin = 0;
  for (var i = 0; i < rounds.length; i++) {
    final (roundMargin, isFinal) = _irvWinnerRoundMargin(town, i, target);
    if (isFinal) {
      finalMargin = roundMargin;
    }
    if (roundMargin < minMargin) {
      minMargin = roundMargin;
    }
  }

  if (forSelfishMover && minMargin >= 10 && finalMargin >= 10) {
    return const _CandidateStanding([1, 1000]);
  }
  return _CandidateStanding([1, minMargin, finalMargin, round1Votes]);
}

(int margin, bool isFinal) _irvWinnerRoundMargin(
  VoteTown town,
  int roundIndex,
  TownCandidate target,
) {
  final round = town.irvElection.rounds[roundIndex];
  final myRoundPlace = round.places.firstWhereOrNull((p) => p.contains(target));
  final myVotes = myRoundPlace?.voteCount ?? 0;
  if (round.isFinal) {
    final runnerUpVotes = _maxOtherVoteCountInRound(town, roundIndex, target);
    return (myVotes - runnerUpVotes, true);
  }
  final lowestOtherVotes = _minOtherVoteCountInRound(town, roundIndex, target);
  return (myVotes - lowestOtherVotes, false);
}

int _maxOtherVoteCountInRound(
  VoteTown town,
  int roundIndex,
  TownCandidate target,
) {
  final round = town.irvElection.rounds[roundIndex];
  var maxVotes = 0;
  for (final place in round.places) {
    if (place.any((c) => c != target) && place.voteCount > maxVotes) {
      maxVotes = place.voteCount;
    }
  }
  return maxVotes;
}

int _minOtherVoteCountInRound(
  VoteTown town,
  int roundIndex,
  TownCandidate target,
) {
  final election = town.irvElection;
  final round = election.rounds[roundIndex];
  final totalActive =
      town.candidates.length -
      election.rounds
          .take(round.number - 1)
          .expand((r) => r.eliminatedCandidates)
          .length;
  if (round.candidates.length < totalActive) {
    return 0;
  }
  var minVotes = 1000;
  for (final place in round.places) {
    if (place.any((c) => c != target) && place.voteCount < minVotes) {
      minVotes = place.voteCount;
    }
  }
  return minVotes;
}

_CandidateStanding _evaluateIrvLoserStanding(
  VoteTown town,
  TownCandidate target, {
  required int overallPlace,
  required int round1Votes,
}) {
  var lastRoundVotes = 0;
  var votesToSurvive = 1000;
  for (final round in town.irvElection.rounds.reversed) {
    final myRoundPlace = round.places.firstWhereOrNull(
      (p) => p.contains(target),
    );
    if (myRoundPlace != null) {
      lastRoundVotes = myRoundPlace.voteCount;
      final higherPlaces = round.places
          .where((p) => p.voteCount > lastRoundVotes)
          .toList(growable: false);
      votesToSurvive = higherPlaces.isNotEmpty
          ? higherPlaces.last.voteCount
          : lastRoundVotes;
      break;
    }
  }

  final deficit = lastRoundVotes - votesToSurvive;
  return _CandidateStanding([0, -overallPlace, deficit, round1Votes]);
}

class const _CandidateStanding(final List<int> metrics)
    implements Comparable<_CandidateStanding> {
  _CandidateStanding negated() =>
      _CandidateStanding([for (final m in metrics) -m]);

  @override
  int compareTo(_CandidateStanding other) {
    final len = min(metrics.length, other.metrics.length);
    for (var i = 0; i < len; i++) {
      final cmp = metrics[i].compareTo(other.metrics[i]);
      if (cmp != 0) {
        return cmp;
      }
    }
    return metrics.length.compareTo(other.metrics.length);
  }
}

class const _MoveScore(
  final _CandidateStanding standing,
  final double tieBreaker,
) implements Comparable<_MoveScore> {
  @override
  int compareTo(_MoveScore other) {
    final cmp = standing.compareTo(other.standing);
    if (cmp != 0) {
      return cmp;
    }
    return tieBreaker.compareTo(other.tieBreaker);
  }
}
