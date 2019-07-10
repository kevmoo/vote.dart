import 'dart:math' as math;

import 'package:flutter_web_ui/ui.dart';
import 'package:vote/vote.dart';

import 'town_candidate.dart';
import 'town_voter.dart';
import 'vote_town_distance_place.dart';

class VoteTown {
  static const votersAcross = 10;
  static const voterSpacing = TownCandidate.candidateSpacing * 2;

  final List<TownCandidate> candidates;

  VoteTown(this.candidates);

  factory VoteTown.random({int candidateCount = 5, int randomSeed}) {
    candidateCount ??= 5;
    assert(candidateCount > 0);
    assert(candidateCount < 2 * votersAcross);
    assert(candidateCount <= 26);

    var candidateNumber = 0;

    final candidates = [
      TownCandidate(
        candidateNumber++,
        const math.Point(
          votersAcross - 1,
          votersAcross - 1,
        ),
      ),
    ];

    final rnd = math.Random(randomSeed);

    while (candidates.length < candidateCount) {
      math.Point<int> point;

      do {
        point = math.Point<int>(
          rnd.nextInt(votersAcross - 1) * 2 + 1,
          rnd.nextInt(votersAcross - 1) * 2 + 1,
        );
      } while (candidates.indexWhere((s) => s.intLocation == point) >= 0);

      candidates.add(TownCandidate(candidateNumber++, point));
    }

    return VoteTown(candidates);
  }

  static List<TownVoter> _createVoters(List<TownCandidate> candidates) {
    TownVoter createVoter(int x, int y) {
      final location = Point(
        voterSpacing / 2 + x * voterSpacing,
        voterSpacing / 2 + y * voterSpacing,
      );

      final rankedCandidates = candidates.toList(growable: false)
        ..sort((a, b) {
          // using distanceSquared because it's fine for comparison -
          // and it avoids a square-root
          final distanceA = (a.location - location).distanceSquared;
          final distanceB = (b.location - location).distanceSquared;

          var value = distanceA.compareTo(distanceB);

          if (value == 0) {
            value = a.id.compareTo(b.id);
          }
          return value;
        });

      return TownVoter(
        x + y * votersAcross,
        location,
        rankedCandidates,
      );
    }

    final voters = [
      for (var y = 0; y < votersAcross; y++)
        for (var x = 0; x < votersAcross; x++) createVoter(x, y),
    ];

    return voters;
  }

  List<TownVoter> get voters => _voters ??= _createVoters(candidates);

  List<TownVoter> _voters;

  List<VoteTownDistancePlace> _distancePlaces;

  List<VoteTownDistancePlace> get distancePlaces =>
      _distancePlaces ??= VoteTownDistancePlace.create(this);

  List<RankedBallot<TownVoter, TownCandidate>> _ballots;

  List<RankedBallot<TownVoter, TownCandidate>> get ballots =>
      _ballots ??= voters
          .map((v) =>
              RankedBallot<TownVoter, TownCandidate>(v, v.closestCandidates))
          .toList(growable: false);

  PluralityElection<TownVoter, TownCandidate> _pluralityElection;

  PluralityElection<TownVoter, TownCandidate> get pluralityElection =>
      _pluralityElection ??= PluralityElection(ballots, candidates: candidates);

  CondorcetElection<TownVoter, TownCandidate> _condorcetElection;

  CondorcetElection<TownVoter, TownCandidate> get condorcetElection =>
      _condorcetElection ??= CondorcetElection(ballots);

  IrvElection<TownVoter, TownCandidate> _irvElection;

  IrvElection<TownVoter, TownCandidate> get irvElection =>
      _irvElection ??= IrvElection(ballots);

  double _bestDistanceCache;

  double get _bestDistance {
    if (_bestDistanceCache == null) {
      final locationSum =
          voters.map((v) => v.location.toOffset()).reduce((a, b) => a + b) /
              voters.length.toDouble();

      _bestDistanceCache =
          _averageVoterDistanceTo(this, Point(locationSum.dx, locationSum.dy));
    }
    return _bestDistanceCache;
  }
}

double _averageVoterDistanceTo(VoteTown town, Point location) =>
    town.voters
        .fold<double>(
            0, (value, voter) => value + (voter.location - location).distance)
        .roundToDouble() /
    town.voters.length;

double averageVoterDistanceTo(VoteTown town, Point location) {
  final value = _averageVoterDistanceTo(town, location);
  assert(value >= town._bestDistance);
  return value - town._bestDistance;
}
