import 'package:test/test.dart';
import 'package:vote/vote.dart';

void main() {
  test('simple', _sample1);
  test('ice cream', _sample2);
  test('3-Way Tie For First', _threeWayTieForFirst);
}

void _sample1() {
  final c = "Candidate 1";
  final v = "Voter 1";
  final b = RankedBallot(v, [c]);

  final ce = CondorcetElection([b]);

  expect(ce, isNotNull);
  expect(ce.singleWinner, equals(c));
  expect(ce.candidates, unorderedEquals([c]));
  expect(ce.ballots, unorderedEquals([b]));
  expect(ce.places.length, equals(1));

  final first = ce.places[0];
  expect(first, unorderedEquals([c]));
}

void _sample2() {
  final canC = "Chocolate";
  final canCC = "Chocolate Chunk";
  final canVan = "Vanilla";

  var voter = 1;

  final ballots = <RankedBallot<Comparable, Comparable>>[];

  // 29 cc, c, v
  for (var i = 0; i < 29; i++) {
    ballots.add(RankedBallot("Voter ${voter++}", [canCC, canC, canVan]));
  }

  // 31 c, cc, v
  for (var i = 0; i < 31; i++) {
    ballots.add(RankedBallot("Voter ${voter++}", [canC, canCC, canVan]));
  }

  // 40 v, c, cc
  for (var i = 0; i < 40; i++) {
    ballots.add(RankedBallot("Voter ${voter++}", [canVan, canC, canCC]));
  }

  final ce = CondorcetElection(ballots);

  expect(ce, isNotNull);
  expect(ce.singleWinner, equals(canC));
  expect(ce.candidates, unorderedEquals([canC, canCC, canVan]));
  expect(ce.ballots, unorderedEquals(ballots));

  expect(ce.places.length, equals(3));

  expect(ce.places[0].place, equals(1));
  expect(ce.places[0], unorderedEquals([canC]));

  expect(ce.places[1].place, equals(2));
  expect(ce.places[1], unorderedEquals([canCC]));

  expect(ce.places[2].place, equals(3));
  expect(ce.places[2], unorderedEquals([canVan]));
}

void _threeWayTieForFirst() {
  // 1st, 4th, 5th, 7th
  // 3,   1,   2,   1
  final cA1 = "A1";
  final cA2 = "A2";
  final cA3 = "A3";
  final cB1 = "B1";
  final cC1 = "C1";
  final cC2 = "C2";
  final cD1 = "D1";

  var voter = 1;

  final ballots = <RankedBallot<Comparable, Comparable>>[
    RankedBallot("Voter ${voter++}", [cA1, cA2, cA3, cB1, cC1, cC2, cD1]),
    RankedBallot("Voter ${voter++}", [cA1, cA2, cA3, cB1, cC2, cC1, cD1]),
    RankedBallot("Voter ${voter++}", [cA2, cA3, cA1, cB1, cC1, cC2, cD1]),
    RankedBallot("Voter ${voter++}", [cA2, cA3, cA1, cB1, cC2, cC1, cD1]),
    RankedBallot("Voter ${voter++}", [cA3, cA1, cA2, cB1, cC1, cC2, cD1]),
    RankedBallot("Voter ${voter++}", [cA3, cA1, cA2, cB1, cC2, cC1, cD1]),
  ];
  CondorcetElection(ballots);
  // TODO: actually test something!
}
