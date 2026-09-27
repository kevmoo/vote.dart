import 'dart:math';

import 'package:collection/collection.dart';
import 'package:vote_widgets/vote_widgets.dart';

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
      Point(7, 9),
      Point(15, 9),
    ]),
    VoteTownPreset.pluralitySpoiler => VoteTown.fromLocations(const [
      Point(7, 9),
      Point(15, 9),
      Point(3, 5),
    ]),
    VoteTownPreset.irvCenterSqueeze => VoteTown.fromLocations(const [
      Point(9, 9),
      Point(5, 7),
      Point(13, 7),
      Point(9, 13),
    ]),
  };
}

class const SimulationStepResult({
  required final VoteTown town,
  required final TownCandidate candidate,
  required final Point<int> fromLocation,
  required final Point<int> toLocation,
  required final bool isMole,
}) {
  bool get moved => fromLocation != toLocation;
}

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

/// Computes a single turn-based strategic move for the candidate at
/// [candidateIndex] within [maxStepDistance] grid units.
SimulationStepResult computeStrategicMove(
  VoteTown town, {
  required int candidateIndex,
  required TargetElectionMethod method,
  required SimulationMode mode,
  double maxStepDistance = 4.0,
}) {
  RangeError.checkValidIndex(candidateIndex, town.candidates);

  final movingCandidate = town.candidates[candidateIndex];
  final startPoint = movingCandidate.intLocation;
  final isMole =
      mode.hasMole &&
      town.candidates.length >= 2 &&
      candidateIndex == town.candidates.length - 1;

  final occupiedByOthers = {
    for (var i = 0; i < town.candidates.length; i++)
      if (i != candidateIndex) town.candidates[i].intLocation,
  };

  final maxDistSq = (maxStepDistance * maxStepDistance).round();
  const upperBound = VoteTown.votersAcross * 2 - 1;

  final reachablePoints = <Point<int>>[startPoint];
  for (var y = 0; y < upperBound; y++) {
    for (var x = 0; x < upperBound; x++) {
      if (x.isEven && y.isEven) {
        // Directly over a voter - skip!
        continue;
      }
      final point = Point(x, y);
      if (point == startPoint || occupiedByOthers.contains(point)) {
        continue;
      }
      if (startPoint.squaredDistanceTo(point) <= maxDistSq) {
        reachablePoints.add(point);
      }
    }
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

  for (final candidatePoint in reachablePoints.skip(1)) {
    final updatedCandidates = town.candidates.toList(growable: false);
    final updatedMoving = TownCandidate(
      movingCandidate.index,
      movingCandidate.hue,
      candidatePoint,
    );
    updatedCandidates[candidateIndex] = updatedMoving;
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
  var votesToSurvive = 100;
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
