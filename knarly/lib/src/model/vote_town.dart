import 'dart:math' as math;

import 'package:flutter_web_ui/ui.dart';

import 'sim.dart';
import 'town_candidate.dart';
import 'vote_town_distance_place.dart';

class VoteTown {
  static const _across = 10;
  static const _spacing = 10.0;

  final List<Sim<int>> voters;
  final List<Sim<String>> candidates;

  VoteTown(this.voters, this.candidates);

  factory VoteTown.random({int candidateCount = 5}) {
    candidateCount ??= 5;
    assert(candidateCount > 0);
    assert(candidateCount < 2 * _across);
    assert(candidateCount <= 26);

    final rnd = math.Random();

    final voters = [
      for (var y = 0; y < _across; y++)
        for (var x = 0; x < _across; x++)
          Sim(
              x + y * _across,
              Point(
                _spacing / 2 + x * _spacing,
                _spacing / 2 + y * _spacing,
              )),
    ];

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
          _spacing + rnd.nextInt(_across - 1) * _spacing,
          _spacing + rnd.nextInt(_across - 1) * _spacing,
        );
      } while (candidates.indexWhere((s) => s.location == point) >= 0);

      candidates.add(TownCandidate(candidateNumber++, point));
    }

    return VoteTown(voters, candidates);
  }

  List<VoteTownDistancePlace> _places;

  List<VoteTownDistancePlace> get places =>
      _places ??= VoteTownDistancePlace.create(this);
}
