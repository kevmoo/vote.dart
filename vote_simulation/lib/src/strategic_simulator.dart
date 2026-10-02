import 'dart:math';

import 'package:collection/collection.dart';

import 'candidate.dart';
import 'town_folk.dart';
import 'vote_town.dart';

enum TargetElectionMethod(final String label) {
  plurality('Plurality'),
  condorcet('Condorcet'),
  irv('IRV'),
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

  final candidatePoints = <Point<double>>[];

  void tryAddPoint(Point<double> rawPoint) {
    final clamped = VoteTown.clampToBounds(rawPoint);
    if (!isLegalPoint(clamped)) {
      return;
    }
    candidatePoints.add(clamped);
  }

  // 1. Always consider staying put and probing toward the center of town.
  tryAddPoint(startPoint);
  final toCenter = VoteTown.center - startPoint;
  if (toCenter.magnitude <= effectiveMaxStep) {
    tryAddPoint(VoteTown.center);
  } else {
    tryAddPoint(
      startPoint + toCenter * (effectiveMaxStep / toCenter.magnitude),
    );
  }

  // 2. Local concentric radial rings around startPoint.
  const ringFractions = [0.15, 0.35, 0.65, 1.0];
  const directions = 16;
  for (final fraction in ringFractions) {
    final radius = effectiveMaxStep * fraction;
    for (var d = 0; d < directions; d++) {
      final angle = (2 * pi * d) / directions;
      tryAddPoint(
        Point<double>(
          startPoint.x + cos(angle) * radius,
          startPoint.y + sin(angle) * radius,
        ),
      );
    }
  }

  // 3. The Mole has no attachment to its own voter base: it searches globally
  // around every candidate's flanks and across the board to find where it can
  // best help or hurt A.
  if (isMole) {
    for (final landmark in [VoteTown.center, ...otherLocations]) {
      for (final radius in [
        TownCandidate.repulsionRadius + 0.5,
        TownCandidate.repulsionRadius + 10.0,
      ]) {
        for (var d = 0; d < 16; d++) {
          final angle = (2 * pi * d) / 16;
          tryAddPoint(
            Point<double>(
              landmark.x + cos(angle) * radius,
              landmark.y + sin(angle) * radius,
            ),
          );
        }
      }
    }
    for (var y = 15.0; y <= 135.0; y += 20.0) {
      for (var x = 15.0; x <= 135.0; x += 20.0) {
        tryAddPoint(Point<double>(x, y));
      }
    }
  } else {
    // For selfish candidates, also sample points just outside personal space
    // around the center if within step reach.
    for (var d = 0; d < 16; d++) {
      final angle = (2 * pi * d) / 16;
      final p = Point<double>(
        VoteTown.center.x + cos(angle) * (TownCandidate.repulsionRadius + 0.5),
        VoteTown.center.y + sin(angle) * (TownCandidate.repulsionRadius + 0.5),
      );
      if (startPoint.distanceTo(p) <= effectiveMaxStep) {
        tryAddPoint(p);
      }
    }
  }

  var bestGlobalPoint = startPoint;
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
    final trialTown = VoteTown(updatedCandidates);

    final trialScore = _evaluateTownForMove(
      trialTown,
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

  // When stepping toward bestGlobalPoint, avoid cutting straight through A's
  // personal space if the Mole is trying to help A.
  var stepPoint = bestGlobalPoint;
  final distToBest = startPoint.distanceTo(bestGlobalPoint);
  if (distToBest > effectiveMaxStep) {
    final targetA = town.candidates.first.location;
    final dir = (bestGlobalPoint - startPoint) * (1.0 / distToBest);
    var rawStep = startPoint + dir * effectiveMaxStep;
    if (isMole &&
        mode == SimulationMode.moleHelpsA &&
        rawStep.distanceTo(targetA) < TownCandidate.repulsionRadius + 10.0) {
      // Deflect around A so the Mole doesn't trample A's center voters while
      // crossing the board to flank a rival.
      final awayFromA = rawStep - targetA;
      final awayDist = awayFromA.magnitude;
      if (awayDist > 1e-4) {
        final deflected =
            targetA +
            awayFromA * ((TownCandidate.repulsionRadius + 12.0) / awayDist);
        final defDelta = deflected - startPoint;
        if (defDelta.magnitude > 1e-4) {
          rawStep =
              startPoint + defDelta * (effectiveMaxStep / defDelta.magnitude);
        }
      }
    }
    if (isLegalPoint(rawStep)) {
      stepPoint = VoteTown.clampToBounds(rawStep);
    } else {
      var minRemainingDist = double.infinity;
      for (final p in candidatePoints) {
        if (startPoint.distanceTo(p) <= effectiveMaxStep + 1e-5) {
          final rem = p.distanceTo(bestGlobalPoint);
          if (rem < minRemainingDist) {
            minRemainingDist = rem;
            stepPoint = p;
          }
        }
      }
    }
  }

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

  const arrivalRadius = 8.0;
  const repulsionRadius = TownCandidate.repulsionRadius;
  const minSep = TownCandidate.minSeparation;
  const repulsionSpan = repulsionRadius - minSep;
  final steerBlend = 1.0 - exp(-dt * 9.0);

  for (var i = 0; i < count; i++) {
    if (onlyCandidateIndex != null && i != onlyCandidateIndex) {
      nextVelocities[i] = const Point(0, 0);
      continue;
    }

    final isMole = mode.hasMole && count >= 2 && i == count - 1;
    final candidateMaxSpeed = isMole ? maxSpeed * 1.35 : maxSpeed;

    final pos = positions[i];
    final target = targets[i];
    final toTarget = target - pos;
    final distToTarget = toTarget.magnitude;

    var desiredVel = const Point<double>(0, 0);
    if (distToTarget > 0.15) {
      final speed = distToTarget < arrivalRadius
          ? candidateMaxSpeed * (distToTarget / arrivalRadius)
          : candidateMaxSpeed;
      desiredVel = toTarget * (speed / distToTarget);
    }

    // Scale repulsion by how actively this candidate is moving toward a target
    // so a stationary candidate sitting at its chosen target cannot be shoved
    // off its spot by approaching rivals.
    final mobilityFactor = (distToTarget / 5.0).clamp(0.0, 1.0);

    var repelVel = const Point<double>(0, 0);
    if (mobilityFactor > 0.01) {
      for (var j = 0; j < count; j++) {
        if (i == j) continue;
        final away = pos - positions[j];
        final dist = away.magnitude;
        if (dist < repulsionRadius + 3.0 && dist > 1e-4) {
          final awayUnit = away * (1.0 / dist);
          if (dist < repulsionRadius) {
            final u = ((repulsionRadius - dist) / repulsionSpan).clamp(
              0.0,
              2.0,
            );
            final u2 = u * u;
            final strength =
                (0.35 * u + 3.0 * u2 * u2) * candidateMaxSpeed * mobilityFactor;
            repelVel += awayUnit * strength;
          }

          // Tangential deflection when approaching personal space.
          final inwardDot =
              desiredVel.x * awayUnit.x + desiredVel.y * awayUnit.y;
          if (inwardDot < 0) {
            final block = ((repulsionRadius + 3.0 - dist) / 5.0).clamp(
              0.0,
              1.0,
            );
            desiredVel -= awayUnit * (inwardDot * block);
          }
        }
      }
    }

    final combinedDesired = desiredVel + repelVel;
    var vel = velocities[i] + (combinedDesired - velocities[i]) * steerBlend;

    if (distToTarget < 0.8 && repelVel.magnitude < 0.5) {
      vel *= 0.5;
    }

    final speed = vel.magnitude;
    if (speed > candidateMaxSpeed * 1.4) {
      vel = vel * ((candidateMaxSpeed * 1.4) / speed);
    }

    nextVelocities[i] = vel;
    positions[i] = VoteTown.clampToBounds(pos + vel * dt);
  }

  // Hard minimum separation safety net: weight projection by candidate speed
  // so anchored candidates aren't bulldozed by moving challengers.
  for (var pass = 0; pass < 4; pass++) {
    for (var i = 0; i < count; i++) {
      for (var j = i + 1; j < count; j++) {
        final diff = positions[i] - positions[j];
        final dist = diff.magnitude;
        if (dist < minSep) {
          final overlap = minSep - dist;
          final unit = dist > 1e-4
              ? diff * (1.0 / dist)
              : Point<double>(cos(i + j), sin(i + j));
          final speedI = nextVelocities[i].magnitude;
          final speedJ = nextVelocities[j].magnitude;
          final totalSpeed = speedI + speedJ;
          final weightI = onlyCandidateIndex == i
              ? 1.0
              : onlyCandidateIndex == j
              ? 0.0
              : totalSpeed > 1e-3
              ? speedI / totalSpeed
              : 0.5;
          final weightJ = 1.0 - weightI;

          positions[i] = VoteTown.clampToBounds(
            positions[i] + unit * (overlap * weightI),
          );
          positions[j] = VoteTown.clampToBounds(
            positions[j] - unit * (overlap * weightJ),
          );
        }
      }
    }
  }

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

  var pairwiseWins = 0;
  var minimaxMargin = 1000;
  var totalMargin = 0;

  for (final other in town.candidates) {
    if (other == target) {
      continue;
    }
    final pair = election.getPair(target, other);
    final diff = (pair.firstOverSecond ?? 0) - (pair.secondOverFirst ?? 0);
    if (diff > 0) {
      pairwiseWins++;
    }

    // In Mole Helps A, don't incentivize the Mole to run to the corner just to
    // inflate how badly A beats the Mole itself, as long as A beats the Mole.
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

  if (minimaxMargin == 1000) {
    minimaxMargin = 0;
  }

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
    // Target wins IRV! Measure minimum survival/victory margin across all
    // rounds so both the winner and any Saboteur Mole recognize center-squeeze
    // vulnerability in early rounds.
    var minMargin = 1000;
    var finalMargin = 0;
    for (final round in election.rounds) {
      final myRoundPlace = round.places.firstWhereOrNull(
        (p) => p.contains(target),
      );
      final myVotes = myRoundPlace?.voteCount ?? 0;

      var compareVotes = 0;
      if (round.isFinal) {
        // Margin over best runner-up in the final round.
        for (final place in round.places) {
          for (final candidate in place) {
            if (candidate != target && place.voteCount > compareVotes) {
              compareVotes = place.voteCount;
            }
          }
        }
        finalMargin = myVotes - compareVotes;
      } else {
        // Margin over the lowest-vote candidate in this elimination round.
        compareVotes = 1000;
        for (final place in round.places) {
          for (final candidate in place) {
            if (candidate != target && place.voteCount < compareVotes) {
              compareVotes = place.voteCount;
            }
          }
        }
        // Account for active candidates with 0 votes not present in places.
        final activeInRound = round.candidates.length;
        final totalActive =
            town.candidates.length -
            election.rounds
                .take(round.number - 1)
                .expand((r) => r.eliminatedCandidates)
                .length;
        if (activeInRound < totalActive) {
          compareVotes = 0;
        }
      }

      final margin = myVotes - compareVotes;
      if (margin < minMargin) {
        minMargin = margin;
      }
    }

    if (forSelfishMover && minMargin >= 10 && finalMargin >= 10) {
      // Comfortably winning IRV without center-squeeze risk: prefer center.
      return const _CandidateStanding([1, 1000]);
    }

    return _CandidateStanding([1, minMargin, finalMargin, round1Votes]);
  }

  // Target was eliminated (or tied/lost in the final round). Find the last
  // round in which target participated and measure how many votes short target
  // was of surviving that round.
  var lastRoundVotes = 0;
  var votesToSurvive = 1000;
  for (final round in election.rounds.reversed) {
    final myRoundPlace = round.places.firstWhereOrNull(
      (p) => p.contains(target),
    );
    if (myRoundPlace != null) {
      lastRoundVotes = myRoundPlace.voteCount;
      // Find the lowest vote count strictly above lastRoundVotes (or the top
      // vote count if in the final round).
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
  return _CandidateStanding([0, -myOverallPlace.place, deficit, round1Votes]);
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
