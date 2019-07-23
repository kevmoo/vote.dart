import 'package:test/test.dart';
import 'package:vote/vote.dart';

import 'test_util.dart';

void main() {
  test('sorted candidates', () {
    const ballots = [
      PluralityBallot(2),
      PluralityBallot(1),
    ];

    PluralityElection(ballots);
  });

  group('with candidates', () {
    test('include candidate with no votes', () {
      const ballots = [
        PluralityBallot(2),
        PluralityBallot(1),
      ];

      final election = PluralityElection(ballots, candidates: const [1, 2, 3]);

      expect(election.places, hasLength(2));
      expect(election.places[0], [1, 2]);
      expect(election.places[1], [3]);
    });

    test('assert if ballot includes candidate that is not present', () {
      const ballots = [
        PluralityBallot(2),
        PluralityBallot(1),
      ];

      expect(
        () => PluralityElection(ballots, candidates: const [3]),
        throwsAssertionError,
      );
    });
  });

  test('tied for 1st', () {
    final c1 = 'candidate 1';
    final c2 = 'candidate 2';
    final c3 = 'candidate 3';

    final ballots = [
      ...Iterable.generate(10, (_) => PluralityBallot(c1)),
      ...Iterable.generate(10, (_) => PluralityBallot(c2)),
      ...Iterable.generate(9, (_) => PluralityBallot(c3))
    ];

    final election = PluralityElection(ballots);
    expect(election.singleWinner, isNull);
    expect(election.places, hasLength(2));

    final firstPlace = election.places[0];
    expect(firstPlace.place, equals(1));
    expect(firstPlace, hasLength(2));

    final thirdPlace = election.places[1];
    expect(thirdPlace.place, equals(3));
    expect(thirdPlace, hasLength(1));
    expect(thirdPlace[0], equals(c3));
  });

  test('single vote, single winner', () {
    final c1 = 'candidate 1';

    final ballots = [PluralityBallot(c1)];

    final election = PluralityElection(ballots);
    expect(election.singleWinner, equals(c1));
    expect(election.places, hasLength(1));

    final firstPlace = election.places[0];
    expect(firstPlace, hasLength(1));
    expect(firstPlace[0], equals(c1));
  });
}
