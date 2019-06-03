import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter_web_ui/ui.dart';
import 'package:vote/vote.dart';

class Sim<T extends Comparable> implements Comparable<Sim<T>> {
  final T id;
  final Point location;

  const Sim(this.id, this.location);

  @override
  bool operator ==(other) => other is Sim && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  int compareTo(Sim<T> other) => id.compareTo(other.id);
}

class VoteTown {
  static const _across = 10;
  static const _spacing = 10.0;

  final List<Sim<int>> voters;
  final List<Sim<String>> candidates;

  VoteTown(this.voters, this.candidates);

  factory VoteTown.random({int candidateCount = 5}) {
    candidateCount ??= 5;
    assert(candidateCount > 0);

    final rnd = math.Random();

    final votes = [
      for (var y = 0; y < _across; y++)
        for (var x = 0; x < _across; x++)
          Sim(
              x + y * _across,
              Point(
                _spacing / 2 + x * _spacing,
                _spacing / 2 + y * _spacing,
              )),
    ];

    var candidateNumber = 1;
    final candidates = [
      Sim(
        (candidateNumber++).toString(),
        const Point(
          _across * _spacing / 2,
          _across * _spacing / 2,
        ),
      ),
      for (var i = 1; i < candidateCount; i++)
        Sim(
          (candidateNumber++).toString(),
          Point(
            rnd.nextDouble() * _across * _spacing,
            rnd.nextDouble() * _across * _spacing,
          ),
        ),
    ];

    return VoteTown(votes, candidates);
  }

  List<VoteTownDistancePlace> get places => VoteTownDistancePlace.create(this);
}

class VoteTownDistancePlace extends ElectionPlace<Sim<String>> {
  final double averageDistance;

  VoteTownDistancePlace._(
    this.averageDistance,
    int place,
    List<Sim<String>> candidates,
  ) : super(place, candidates);

  static List<VoteTownDistancePlace> create(VoteTown town) {
    final distances = Map<Sim<String>, double>.fromIterable(town.candidates,
        value: (candidate) =>
            town.voters
                .fold<double>(
                    0,
                    (value, voter) =>
                        value +
                        (voter.location - (candidate as Sim<String>).location)
                            .distance)
                .roundToDouble() /
            town.voters.length);

    final groups = groupBy(distances.keys, (key) => distances[key]);

    var place = 1;
    return groups.entries.map((e) {
      final placeValue = place;
      place += e.value.length;
      return VoteTownDistancePlace._(e.key, placeValue, e.value);
    }).toList(growable: false);
  }
}
