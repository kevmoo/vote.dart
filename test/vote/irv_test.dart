import 'package:test/test.dart';
import 'package:vote/src/vote/irv_election.dart';
import 'package:vote/src/vote/ranked_ballot.dart';

void main() {
  test('no transfers between eliminated', _testNoTransfersBetweenEliminated);
  test('one candidate', _testOneCandidate);
  test('three candidates, tied', _threeWayTieForFirst);
  test('Ice Cream', _testIceCream);
}

void _testNoTransfersBetweenEliminated() {
  final canA = 'A';
  final canB = 'B';
  final canC = 'C';
  final canD = 'D';

  var voter = 1;

  final ballots = new List<RankedBallot>();
  for (var i = 0; i < 10; i++) {
    ballots.add(new RankedBallot("Voter ${voter++}", [canA]));
  }

  for (var i = 0; i < 8; i++) {
    ballots.add(new RankedBallot("Voter ${voter++}", [canB]));
  }

  for (var i = 0; i < 2; i++) {
    ballots.add(new RankedBallot("Voter ${voter++}", [canC, canD]));
  }

  for (var i = 0; i < 2; i++) {
    ballots.add(new RankedBallot("Voter ${voter++}", [canD, canC]));
  }

  var elec = new IrvElection(ballots);

  expect(elec, isNotNull);
  //expect(elec.singleWinner, equals(canC));
  expect(elec.candidates, unorderedEquals([canA, canB, canC, canD]));
  expect(elec.ballots, unorderedEquals(ballots));

  expect(elec.rounds.length, 2);

  final firstRound = elec.rounds.first;
  expect(firstRound.eliminatedCandidates, unorderedEquals([canC, canD]));

  final elimC = firstRound.getElimination(canC);
  expect(elimC.getTransferCount(canA), 0);
  expect(elimC.getTransferCount(canB), 0);
  expect(elimC.getTransferCount(canC), 0);
  expect(elimC.getTransferCount(canD), 0);

  final elimD = firstRound.getElimination(canD);
  expect(elimD.getTransferCount(canA), 0);
  expect(elimD.getTransferCount(canB), 0);
  expect(elimD.getTransferCount(canC), 0);
  expect(elimD.getTransferCount(canD), 0);
}

void _testOneCandidate() {
  var c = "Candidate 1";
  var v = "Voter 1";
  var b = new RankedBallot(v, [c]);

  var ce = new IrvElection([b]);

  expect(ce, isNotNull);
  //expect(ce.singleWinner, equals(c));
  //expect(ce.candidates, unorderedEquals([c]));
  expect(ce.rounds.length, 1);
  //expect(ce.places.length, equals(1));

  //var first = ce.places[0];
  //expect(first, unorderedEquals([c]));
}

void _testIceCream() {
  var canC = "Chocolate";
  var canCC = "Chocolate Chunk";
  var canVan = "Vanilla";

  var voter = 1;

  var ballots = new List<RankedBallot>();

  // 29 cc, c, v
  for (var i = 0; i < 29; i++) {
    ballots.add(new RankedBallot("Voter ${voter++}", [canCC, canC, canVan]));
  }

  // 31 c, cc, v
  for (var i = 0; i < 31; i++) {
    ballots.add(new RankedBallot("Voter ${voter++}", [canC, canCC, canVan]));
  }

  // 40 v, c, cc
  for (var i = 0; i < 40; i++) {
    ballots.add(new RankedBallot("Voter ${voter++}", [canVan, canC, canCC]));
  }

  var ce = new IrvElection(ballots);

  expect(ce, isNotNull);
  //expect(ce.singleWinner, equals(canC));
  expect(ce.candidates, unorderedEquals([canC, canCC, canVan]));
  expect(ce.ballots, unorderedEquals(ballots));

  final firstRound = ce.rounds[0];
  expect(firstRound.places.length, 3);
  expect(firstRound.candidates, hasLength(3));

  final firstElimination = firstRound.eliminations.single;
  expect(firstElimination.candidate, canCC);
  expect(firstElimination.transferedCandidates, unorderedEquals([canC]));
  expect(firstElimination.getTransferCount(canC), 29);

  /*
  expect(ce.places.length, equals(3));

  expect(ce.places[0].place, equals(1));
  expect(ce.places[0], unorderedEquals([canC]));

  expect(ce.places[1].place, equals(2));
  expect(ce.places[1], unorderedEquals([canCC]));

  expect(ce.places[2].place, equals(3));
  expect(ce.places[2], unorderedEquals([canVan]));
  */
}

void _threeWayTieForFirst() {
  // 1st, 4th, 5th, 7th
  // 3,   1,   2,   1
  var cA1 = "A1";
  var cA2 = "A2";
  var cA3 = "A3";
  var cB1 = "B1";
  var cC1 = "C1";
  var cC2 = "C2";
  var cD1 = "D1";

  var voter = 1;

  var ballots = new List<RankedBallot>();

  ballots.add(new RankedBallot(
      "Voter ${voter++}", [cA1, cA2, cA3, cB1, cC1, cC2, cD1]));
  ballots.add(new RankedBallot(
      "Voter ${voter++}", [cA1, cA2, cA3, cB1, cC2, cC1, cD1]));
  ballots.add(new RankedBallot(
      "Voter ${voter++}", [cA2, cA3, cA1, cB1, cC1, cC2, cD1]));
  ballots.add(new RankedBallot(
      "Voter ${voter++}", [cA2, cA3, cA1, cB1, cC2, cC1, cD1]));
  ballots.add(new RankedBallot(
      "Voter ${voter++}", [cA3, cA1, cA2, cB1, cC1, cC2, cD1]));
  ballots.add(new RankedBallot(
      "Voter ${voter++}", [cA3, cA1, cA2, cB1, cC2, cC1, cD1]));

  new IrvElection(ballots);
}
