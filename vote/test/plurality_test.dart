import 'package:test/test.dart';
import 'package:vote/vote.dart';

import 'plurality_test_shared.dart';
import 'test_util.dart';

void main() {
  registerPluralityTests((items, {List<String> candidates}) =>
      PluralityElection(items, candidates: candidates));

  test('sorted candidates', () {
    const ballots = [
      PluralityBallot(2),
      PluralityBallot(1),
    ];

    PluralityElection(ballots);
  });

  group('with candidates', () {
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

    test('include candidate with no votes', () {
      const ballots = [
        PluralityBallot('2'),
        PluralityBallot('1'),
      ];

      final election =
          PluralityElection(ballots, candidates: const ['1', '2', '3']);

      expect(election.places, hasLength(2));
      expect(election.places[0], ['1', '2']);
      expect(election.places[1], ['3']);
    });
  });
}
