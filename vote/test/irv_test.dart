import 'package:test/test.dart';
import 'package:vote/vote.dart';

import 'plurality_test_shared.dart';

void main() {
  registerPluralityTests(
    (
      List<PluralityBallot<String>> ballots, {
      List<String>? candidates,
    }) =>
        IrvElection(
      ballots.map((e) => RankedBallot([e.choice])).toList(),
      candidates: candidates,
    ),
  );

  test('no transfers between eliminated', () {
    final canA = 'A';
    final canB = 'B';
    final canC = 'C';
    final canD = 'D';

    final ballots = [
      for (var i = 0; i < 10; i++) RankedBallot([canA]),
      for (var i = 0; i < 8; i++) RankedBallot([canB]),
      for (var i = 0; i < 2; i++) RankedBallot([canC, canD]),
      for (var i = 0; i < 2; i++) RankedBallot([canD, canC])
    ];

    final election = IrvElection(ballots);

    expect(election.hasSingleWinner, isTrue);
    expect(election.singleWinner, canA);
    expect(election.candidates, unorderedEquals([canA, canB, canC, canD]));
    expect(election.ballots, unorderedEquals(ballots));

    expect(election.rounds, hasLength(2));

    final firstRound = election.rounds.first;
    expect(firstRound.eliminatedCandidates, unorderedEquals([canC, canD]));

    final eliminationC = firstRound.eliminationForCandidate(canC)!;
    expect(eliminationC.getTransferCount(canA), 0);
    expect(eliminationC.getTransferCount(canB), 0);
    expect(eliminationC.getTransferCount(canC), 0);
    expect(eliminationC.getTransferCount(canD), 0);

    final eliminationD = firstRound.eliminationForCandidate(canD)!;
    expect(eliminationD.getTransferCount(canA), 0);
    expect(eliminationD.getTransferCount(canB), 0);
    expect(eliminationD.getTransferCount(canC), 0);
    expect(eliminationD.getTransferCount(canD), 0);
  });

  test('one candidate', () {
    final c = 'Candidate 1';
    final b = RankedBallot([c]);

    final ce = IrvElection([b]);

    expect(ce.hasSingleWinner, isTrue);
    expect(ce.singleWinner, equals(c));
    expect(ce.candidates, [c]);
    expect(ce.rounds, hasLength(1));
    expect(ce.places.single, [c]);
  });

  test('three candidates, tied', () {
    // 1st, 4th, 5th, 7th
    // 3,   1,   2,   1
    final cA1 = 'A1';
    final cA2 = 'A2';
    final cA3 = 'A3';
    final cB1 = 'B1';
    final cC1 = 'C1';
    final cC2 = 'C2';
    final cD1 = 'D1';

    final ballots = [
      RankedBallot([cA1, cA2, cA3, cB1, cC1, cC2, cD1]),
      RankedBallot([cA1, cA2, cA3, cB1, cC2, cC1, cD1]),
      RankedBallot([cA2, cA3, cA1, cB1, cC1, cC2, cD1]),
      RankedBallot([cA2, cA3, cA1, cB1, cC2, cC1, cD1]),
      RankedBallot([cA3, cA1, cA2, cB1, cC1, cC2, cD1]),
      RankedBallot([cA3, cA1, cA2, cB1, cC2, cC1, cD1]),
    ];

    final election = IrvElection(ballots);

    expect(election.rounds, hasLength(1));
    final singleRound = election.rounds.single;

    expect(singleRound.isFinal, isTrue);
    expect(singleRound.places, hasLength(1));

    final singlePlace = singleRound.places.single;

    expect(singlePlace.voteCount, 2);
    expect(singlePlace, [cA1, cA2, cA3]);
  });

  test('Ice Cream', () {
    final canC = 'Chocolate';
    final canCC = 'Chocolate Chunk';
    final canVan = 'Vanilla';

    final ballots = [
      // 29 cc, c, v
      for (var i = 0; i < 29; i++) RankedBallot([canCC, canC, canVan]),

      // 31 c, cc, v
      for (var i = 0; i < 31; i++) RankedBallot([canC, canCC, canVan]),

      // 40 v, c, cc
      for (var i = 0; i < 40; i++) RankedBallot([canVan, canC, canCC]),
    ];

    final ce = IrvElection(ballots);

    expect(ce, isNotNull);
    expect(ce.singleWinner, equals(canC));
    expect(ce.candidates, unorderedEquals([canC, canCC, canVan]));
    expect(ce.ballots, unorderedEquals(ballots));

    final firstRound = ce.rounds[0];
    expect(firstRound.places, hasLength(3));
    expect(firstRound.candidates, hasLength(3));

    final firstElimination = firstRound.eliminations.single;
    expect(firstElimination.candidate, canCC);
    expect(firstElimination.transferredCandidates, unorderedEquals([canC]));
    expect(firstElimination.getTransferCount(canC), 29);

    expect(ce.places, hasLength(3));

    expect(ce.places[0].place, 1);
    expect(ce.places[0], [canC]);

    expect(ce.places[1].place, 2);
    expect(ce.places[1], [canVan]);

    expect(ce.places[2].place, 3);
    expect(ce.places[2], [canCC]);
  });
}
