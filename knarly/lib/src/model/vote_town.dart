import 'dart:math';

import 'package:vote/vote.dart';

import 'election_data.dart';
import 'town_folk.dart';
import 'vote_town_distance_place.dart';

class VoteTown extends ElectionData {
  static const votersAcross = 10;
  static const voterSpacing = TownCandidate.candidateSpacing * 2;

  @override
  final List<TownCandidate> candidates;

  VoteTown(this.candidates);

  factory VoteTown.random({int candidateCount = 5, int? randomSeed}) {
    assert(candidateCount > 0);
    assert(candidateCount < 2 * votersAcross);
    assert(candidateCount <= 26);

    var candidateNumber = 0;

    final candidates = [
      TownCandidate.letter(
        candidateNumber++,
        const Point(
          votersAcross - 1,
          votersAcross - 1,
        ),
      ),
    ];

    final rnd = Random(randomSeed);

    while (candidates.length < candidateCount) {
      Point<int> point;

      do {
        point = Point<int>(
          rnd.nextInt(votersAcross - 1) * 2 + 1,
          rnd.nextInt(votersAcross - 1) * 2 + 1,
        );
      } while (candidates.indexWhere((s) => s.intLocation == point) >= 0);

      candidates.add(TownCandidate.letter(candidateNumber++, point));
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
          final distanceA =
              (a.location - location).squaredDistanceTo(const Point(0, 0));
          final distanceB =
              (b.location - location).squaredDistanceTo(const Point(0, 0));

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

  List<TownVoter>? _voters;

  List<VoteTownDistancePlace>? _distancePlaces;

  List<VoteTownDistancePlace> get distancePlaces =>
      _distancePlaces ??= VoteTownDistancePlace.create(this);

  List<RankedBallot<TownCandidate>>? _ballots;

  @override
  List<RankedBallot<TownCandidate>> get ballots => _ballots ??= voters
      .map((v) => RankedBallot<TownCandidate>(v.closestCandidates))
      .toList(growable: false);

  double? _bestDistanceCache;

  double get _bestDistance {
    if (_bestDistanceCache == null) {
      final locationSum =
          voters.map((v) => v.location).reduce((a, b) => a + b) *
              (1 / voters.length.toDouble());

      _bestDistanceCache = _averageVoterDistanceTo(this, locationSum);
    }
    return _bestDistanceCache!;
  }
}

double _averageVoterDistanceTo(VoteTown town, Point<double> location) =>
    town.voters
        .fold<double>(
            0, (value, voter) => value + voter.location.distanceTo(location))
        .roundToDouble() /
    town.voters.length;

double averageVoterDistanceTo(VoteTown town, Point<double> location) {
  final value = _averageVoterDistanceTo(town, location);
  assert(value >= town._bestDistance);
  return value - town._bestDistance;
}
