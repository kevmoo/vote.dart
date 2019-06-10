import 'dart:math' as math;

import 'package:flutter_web_ui/ui.dart';
import 'package:vote/vote.dart';

import 'town_candidate.dart';
import 'town_voter.dart';
import 'vote_town_distance_place.dart';

final _rnd = math.Random(2);

class VoteTown {
  static const _across = 10;
  static const _spacing = 10.0;

  final List<TownVoter> voters;
  final List<TownCandidate> candidates;

  VoteTown(this.voters, this.candidates);

  factory VoteTown.random({int candidateCount = 5}) {
    candidateCount ??= 5;
    assert(candidateCount > 0);
    assert(candidateCount < 2 * _across);
    assert(candidateCount <= 26);

    var candidateNumber = 0;

    final candidates = [
      TownCandidate(
        candidateNumber++,
        const Point(
          _across * _spacing / 2,
          _across * _spacing / 2,
        ),
      ),
    ];

    while (candidates.length < candidateCount) {
      Point point;

      do {
        point = Point(
          _spacing + _rnd.nextInt(_across - 1) * _spacing,
          _spacing + _rnd.nextInt(_across - 1) * _spacing,
        );
      } while (candidates.indexWhere((s) => s.location == point) >= 0);

      candidates.add(TownCandidate(candidateNumber++, point));
    }

    TownVoter createVoter(int x, int y) {
      final location = Point(
        _spacing / 2 + x * _spacing,
        _spacing / 2 + y * _spacing,
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
        x + y * _across,
        location,
        rankedCandidates,
      );
    }

    final voters = [
      for (var y = 0; y < _across; y++)
        for (var x = 0; x < _across; x++) createVoter(x, y),
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
      _pluralityElection ??= PluralityElection(ballots);
}
