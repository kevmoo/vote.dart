import 'package:test/test.dart';
import 'package:vote/vote.dart';

import 'plurality_test_shared.dart';

void main() {
  registerPluralityTests(
    (
      List<PluralityBallot<String>> ballots, {
      List<String>? candidates,
    }) =>
        ApprovalElection(
      ballots.map((e) => ApprovalBallot({e.choice})).toList(),
      candidates: candidates,
    ),
  );

  group('common favorite', () {
    final a = 'a', b = 'b', c = 'c', d = 'd';

    test('tie one vote', () {
      final ballots = [
        ApprovalBallot({a}),
        ApprovalBallot({b}),
        ApprovalBallot({c}),
      ];

      final election = ApprovalElection(ballots, candidates: {a, b, c, d});

      expect(election.hasSingleWinner, isFalse);
      expect(election.singleWinner, isNull);
      expect(election.places, hasLength(2));
      expect(election.places.first, [a, b, c]);
      expect(election.places.last, [d]);
    });

    test('tie circular vote', () {
      final ballots = [
        ApprovalBallot({a, b}),
        ApprovalBallot({b, c}),
        ApprovalBallot({c, a}),
      ];

      final election = ApprovalElection(ballots, candidates: {a, b, c, d});

      expect(election.hasSingleWinner, isFalse);
      expect(election.singleWinner, isNull);
      expect(election.places, hasLength(2));
      expect(election.places.first, [a, b, c]);
      expect(election.places.last, [d]);
    });

    test('common favorite', () {
      final ballots = [
        ApprovalBallot({a, d}),
        ApprovalBallot({b, d}),
        ApprovalBallot({c, d}),
      ];

      final election = ApprovalElection(ballots, candidates: {a, b, c, d});

      expect(election.hasSingleWinner, isTrue);
      expect(election.singleWinner, d);
      expect(election.places, hasLength(2));
      expect(election.places.first, [d]);
      expect(election.places.last, [a, b, c]);
    });

    test('liking everyone changes nothing', () {
      final ballots = [
        ApprovalBallot({a, d}),
        ApprovalBallot({b, d}),
        ApprovalBallot({c, d}),
        ApprovalBallot({a, b, c, d}),
      ];

      final election = ApprovalElection(ballots, candidates: {a, b, c, d});

      expect(election.hasSingleWinner, isTrue);
      expect(election.singleWinner, d);
      expect(election.places, hasLength(2));
      expect(election.places.first, [d]);
      expect(election.places.last, [a, b, c]);
    });
  });
}
