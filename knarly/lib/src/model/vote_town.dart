import 'dart:math' as math;

import 'package:flutter_web_ui/ui.dart';
import 'package:vote/vote.dart';

import 'town_candidate.dart';
import 'town_voter.dart';
import 'vote_town_distance_place.dart';

class VoteTown {
  static const votersAcross = 10;
  static const voterSpacing = 10.0;

  final List<TownVoter> voters;
  final List<TownCandidate> candidates;

  VoteTown(this.voters, this.candidates);

  factory VoteTown.random({int candidateCount = 5, int randomSeed}) {
    candidateCount ??= 5;
    assert(candidateCount > 0);
    assert(candidateCount < 2 * votersAcross);
    assert(candidateCount <= 26);

    var candidateNumber = 0;

    final candidates = [
      TownCandidate(
        candidateNumber++,
        const Point(
          votersAcross * voterSpacing / 2,
          votersAcross * voterSpacing / 2,
        ),
      ),
    ];

    final rnd = math.Random(randomSeed);

    while (candidates.length < candidateCount) {
      Point point;

      do {
        point = Point(
          voterSpacing + rnd.nextInt(votersAcross - 1) * voterSpacing,
          voterSpacing + rnd.nextInt(votersAcross - 1) * voterSpacing,
        );
      } while (candidates.indexWhere((s) => s.location == point) >= 0);

      candidates.add(TownCandidate(candidateNumber++, point));
    }

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

    return VoteTown(voters, candidates);
  }

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
}
