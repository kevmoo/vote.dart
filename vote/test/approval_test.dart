import 'package:test/test.dart';
import 'package:vote/vote.dart';

import 'plurality_test_shared.dart';

void main() {
  registerPluralityTests(
    (List<PluralityBallot<String>> ballots, {List<String>? candidates}) =>
        ApprovalElection(
          ballots.map((e) => ApprovalBallot({e.choice})).toList(),
          candidates: candidates,
        ),
  );

  group('common favorite', () {
    const a = 'a', b = 'b', c = 'c', d = 'd';

    test('tie one vote', () {
      final ballots = [
        ApprovalBallot(const {a}),
        ApprovalBallot(const {b}),
        ApprovalBallot(const {c}),
      ];

      final election = ApprovalElection(
        ballots,
        candidates: const {a, b, c, d},
      );

      expect(election.hasSingleWinner, isFalse);
      expect(election.singleWinner, isNull);
      expect(election.places, hasLength(2));
      expect(election.places.first, [a, b, c]);
      expect(election.places.last, [d]);
    });

    test('tie circular vote', () {
      final ballots = [
        ApprovalBallot(const {a, b}),
        ApprovalBallot(const {b, c}),
        ApprovalBallot(const {c, a}),
      ];

      final election = ApprovalElection(
        ballots,
        candidates: const {a, b, c, d},
      );

      expect(election.hasSingleWinner, isFalse);
      expect(election.singleWinner, isNull);
      expect(election.places, hasLength(2));
      expect(election.places.first, [a, b, c]);
      expect(election.places.last, [d]);
    });

    test('common favorite', () {
      final ballots = [
        ApprovalBallot(const {a, d}),
        ApprovalBallot(const {b, d}),
        ApprovalBallot(const {c, d}),
      ];

      final election = ApprovalElection(
        ballots,
        candidates: const {a, b, c, d},
      );

      expect(election.hasSingleWinner, isTrue);
      expect(election.singleWinner, d);
      expect(election.places, hasLength(2));
      expect(election.places.first, [d]);
      expect(election.places.last, [a, b, c]);
    });

    test('liking everyone changes nothing', () {
      final ballots = [
        ApprovalBallot(const {a, d}),
        ApprovalBallot(const {b, d}),
        ApprovalBallot(const {c, d}),
        ApprovalBallot(const {a, b, c, d}),
      ];

      final election = ApprovalElection(
        ballots,
        candidates: const {a, b, c, d},
      );

      expect(election.hasSingleWinner, isTrue);
      expect(election.singleWinner, d);
      expect(election.places, hasLength(2));
      expect(election.places.first, [d]);
      expect(election.places.last, [a, b, c]);
    });
  });
}
