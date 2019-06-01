import 'dart:math' as math;

import 'package:flutter_web_ui/ui.dart';

class Sim<T extends Comparable> {
  final T id;
  final Point location;

  Sim(this.id, this.location);

  @override
  bool operator ==(other) => other is Sim && id == other.id;

  @override
  int get hashCode => id.hashCode;
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

    final candidates = [
      for (var i = 0; i < candidateCount; i++)
        Sim(
            i.toString(),
            Point(
              rnd.nextDouble() * _across * _spacing,
              rnd.nextDouble() * _across * _spacing,
            )),
    ];

    return VoteTown(votes, candidates);
  }
}
