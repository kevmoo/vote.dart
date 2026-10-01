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
      Point(45, 55),
      Point(105, 55),
      Point(75, 108),
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

  final otherLocations = [
    for (var i = 0; i < town.candidates.length; i++)
      if (i != candidateIndex) town.candidates[i].location,
  ];

  bool isLegalPoint(Point<double> p) => otherLocations.every(
    (other) => other.distanceTo(p) >= TownCandidate.minSeparation + 1.5,
  );

  final candidatePoints = <Point<double>>[];

  void tryAddPoint(Point<double> rawPoint) {
    final clamped = VoteTown.clampToBounds(rawPoint);
    if (startPoint.distanceTo(clamped) > maxStepDistance + 1e-6) {
      return;
    }
    if (!isLegalPoint(clamped)) {
      return;
    }
    candidatePoints.add(clamped);
  }

  // Sample concentric radial rings around startPoint.
  const ringFractions = [0.12, 0.28, 0.50, 0.75, 1.0];
  const directions = 16;
  for (final fraction in ringFractions) {
    final radius = maxStepDistance * fraction;
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

  // Also sample direct probes toward key landmarks (center, A, rivals).
  void addProbeToward(Point<double> landmark) {
    final delta = landmark - startPoint;
    final dist = delta.magnitude;
    if (dist < 0.5) return;
    final stepDist = min(dist, maxStepDistance);
    final unit = delta * (1.0 / dist);
    tryAddPoint(startPoint + unit * stepDist);
    // For landmarks occupied by another candidate, also probe just outside
    // minSeparation around that landmark.
    for (var d = 0; d < 8; d++) {
      final angle = (2 * pi * d) / 8;
      final offset = Point<double>(
        cos(angle) * (TownCandidate.minSeparation + 2.0),
        sin(angle) * (TownCandidate.minSeparation + 2.0),
      );
      final flankTarget = landmark + offset;
      final flankDelta = flankTarget - startPoint;
      final flankDist = flankDelta.magnitude;
      if (flankDist > 0.5) {
        tryAddPoint(
          startPoint +
              flankDelta * (min(flankDist, maxStepDistance) / flankDist),
        );
      }
    }
  }

  addProbeToward(VoteTown.center);
  for (final other in otherLocations) {
    addProbeToward(other);
  }

  var bestPoint = startPoint;
  var bestTown = town;
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
      bestPoint = candidatePoint;
      bestTown = trialTown;
    }
  }

  return SimulationStepResult(
    town: bestTown,
    candidate: bestTown.candidates[candidateIndex],
    fromLocation: startPoint,
    toLocation: bestPoint,
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
  int? onlyCandidateIndex,
  double maxSpeed = 48.0,
}) {
  final dt = dtSeconds.clamp(0.001, 0.05);
  final count = town.candidates.length;
  final positions = [for (final c in town.candidates) c.location];
  final nextVelocities = List<Point<double>>.of(velocities);

  const arrivalRadius = 10.0;
  const repulsionRadius = TownCandidate.repulsionRadius;
  const minSep = TownCandidate.minSeparation;
  const repulsionSpan = repulsionRadius - minSep;
  final steerBlend = 1.0 - exp(-dt * 7.5);

  for (var i = 0; i < count; i++) {
    if (onlyCandidateIndex != null && i != onlyCandidateIndex) {
      nextVelocities[i] = const Point(0, 0);
      continue;
    }

    final pos = positions[i];
    final target = targets[i];
    final toTarget = target - pos;
    final distToTarget = toTarget.magnitude;

    var desiredVel = const Point<double>(0, 0);
    if (distToTarget > 0.15) {
      final speed = distToTarget < arrivalRadius
          ? maxSpeed * (distToTarget / arrivalRadius)
          : maxSpeed;
      desiredVel = toTarget * (speed / distToTarget);
    }

    // Steeply ramping repulsion from nearby candidates + tangential deflection
    // of inward desired velocity so candidates slide around each other and
    // strongly resist overlap.
    var repelVel = const Point<double>(0, 0);
    for (var j = 0; j < count; j++) {
      if (i == j) continue;
      final away = pos - positions[j];
      final dist = away.magnitude;
      if (dist < repulsionRadius && dist > 1e-4) {
        final awayUnit = away * (1.0 / dist);
        final u = ((repulsionRadius - dist) / repulsionSpan).clamp(0.0, 2.0);
        final u2 = u * u;
        // Gentle outer cushion (0.35 * u) + fast quartic barrier (3.2 * u^4).
        final strength = (0.35 * u + 3.2 * u2 * u2) * maxSpeed;
        repelVel += awayUnit * strength;

        // Strip inward velocity component when approaching personal space so
        // desiredVel slides tangentially around the neighbor.
        if (dist < minSep + 6.0) {
          final inwardDot =
              desiredVel.x * awayUnit.x + desiredVel.y * awayUnit.y;
          if (inwardDot < 0) {
            final block = ((minSep + 6.0 - dist) / 6.0).clamp(0.0, 1.0);
            desiredVel -= awayUnit * (inwardDot * block);
          }
        }
      }
    }

    final combinedDesired = desiredVel + repelVel;
    var vel = velocities[i] + (combinedDesired - velocities[i]) * steerBlend;

    // Extra damping when settled at target with minimal repulsion.
    if (distToTarget < 1.0 && repelVel.magnitude < 1.0) {
      vel *= 0.7;
    }

    final maxAllowedSpeed = repelVel.magnitude > maxSpeed
        ? min(maxSpeed * 1.8, repelVel.magnitude)
        : maxSpeed;
    final speed = vel.magnitude;
    if (speed > maxAllowedSpeed) {
      vel = vel * (maxAllowedSpeed / speed);
    }

    nextVelocities[i] = vel;
    positions[i] = VoteTown.clampToBounds(pos + vel * dt);
  }

  // Enforce hard minimum separation safety net and strip inward normal
  // velocity so candidates never overlap.
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
          if (onlyCandidateIndex == i) {
            positions[i] = VoteTown.clampToBounds(positions[j] + unit * minSep);
          } else if (onlyCandidateIndex == j) {
            positions[j] = VoteTown.clampToBounds(positions[i] - unit * minSep);
          } else {
            positions[i] = VoteTown.clampToBounds(
              positions[i] + unit * (overlap * 0.5),
            );
            positions[j] = VoteTown.clampToBounds(
              positions[j] - unit * (overlap * 0.5),
            );
          }

          final relVel = nextVelocities[i] - nextVelocities[j];
          final vn = relVel.x * unit.x + relVel.y * unit.y;
          if (vn < 0) {
            final impulse = unit * (vn * 0.5);
            if (onlyCandidateIndex == null || onlyCandidateIndex == i) {
              nextVelocities[i] -= impulse;
            }
            if (onlyCandidateIndex == null || onlyCandidateIndex == j) {
              nextVelocities[j] += impulse;
            }
          }
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
    final standing = _evaluateStanding(town, movingCandidate, method);
    // Tie-break by moving closer to the geometric center of town.
    final centerBonus = -averageVoterDistanceTo(town, movingCandidate.location);
    return _MoveScore(standing, centerBonus);
  }

  final targetA = town.candidates.first;
  final standingA = _evaluateStanding(town, targetA, method);

  if (mode == SimulationMode.moleHelpsA) {
    // Find A's strongest non-Mole rival so the Mole walks toward that rival
    // when local steps haven't flipped a voter yet.
    final rivals = town.candidates
        .where((c) => c != targetA && c != movingCandidate)
        .toList(growable: false);

    var tieBreak = 0.0;
    if (rivals.isNotEmpty) {
      final topRival = maxBy(
        rivals,
        (r) => _evaluateStanding(town, r, method),
      )!;
      tieBreak = -movingCandidate.location.distanceTo(topRival.location);
    }
    return _MoveScore(standingA, tieBreak);
  } else {
    assert(mode == SimulationMode.moleHurtsA);
    // Saboteur Mole wants to minimize A's standing, and breaks flat ties by
    // moving closer to A to shadow/squeeze A.
    final tieBreak = -movingCandidate.location.distanceTo(targetA.location);
    return _MoveScore(standingA.negated(), tieBreak);
  }
}

_CandidateStanding _evaluateStanding(
  VoteTown town,
  TownCandidate target,
  TargetElectionMethod method,
) => switch (method) {
  TargetElectionMethod.plurality => _evaluatePlurality(town, target),
  TargetElectionMethod.condorcet => _evaluateCondorcet(town, target),
  TargetElectionMethod.irv => _evaluateIrv(town, target),
};

_CandidateStanding _evaluatePlurality(VoteTown town, TownCandidate target) {
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
  return _CandidateStanding([-myPlace.place, margin, myVotes]);
}

_CandidateStanding _evaluateCondorcet(VoteTown town, TownCandidate target) {
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
    if (diff < minimaxMargin) {
      minimaxMargin = diff;
    }
    totalMargin += diff;
  }

  if (town.candidates.length <= 1) {
    minimaxMargin = 0;
  }

  return _CandidateStanding([
    -myPlace.place,
    pairwiseWins,
    minimaxMargin,
    totalMargin,
  ]);
}

_CandidateStanding _evaluateIrv(VoteTown town, TownCandidate target) {
  final election = town.irvElection;
  final myOverallPlace = election.places.firstWhere((p) => p.contains(target));

  final round1Place = election.rounds.first.places.firstWhereOrNull(
    (p) => p.contains(target),
  );
  final round1Votes = round1Place?.voteCount ?? 0;

  if (myOverallPlace.place == 1) {
    // Target wins IRV! Measure minimum survival/victory margin across all
    // rounds so both the winner and any Saboteur Mole recognize center-squeeze
    // vulnerability in early rounds.
    var minMargin = 1000;
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

    return _CandidateStanding([-1, minMargin, round1Votes]);
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
  return _CandidateStanding([-myOverallPlace.place, deficit, round1Votes]);
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
