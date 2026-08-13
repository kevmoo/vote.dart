import 'package:test/test.dart';
import 'package:vote/vote.dart';

import 'test_util.dart';

void main() {
  final c1 = 'Can 1';
  final c2 = 'Can 2';

  test('no dupe candidates', () {
    expect(() {
      CondorcetPair(c1, c1);
    }, throwsAssertionError);
  });

  test('omitting some candidates', () {
    final b1 = RankedBallot([c1]);
    final pair = CondorcetPair(c1, c2, [b1]);

    expect(pair.candidate1, c1);
    expect(pair.candidate2, c2);
    expect(pair.firstOverSecond, 1);
    expect(pair.secondOverFirst, 0);
    expect(pair.ties, 0);

    final b2 = RankedBallot([c2]);
    final pair2 = CondorcetPair(c1, c2, [b2]);

    expect(pair2.candidate1, c1);
    expect(pair2.candidate2, c2);
    expect(pair2.firstOverSecond, 0);
    expect(pair2.secondOverFirst, 1);
    expect(pair2.ties, 0);

    final pair3 = CondorcetPair(c1, c2, [
      b1,
      b2,
      RankedBallot(const ['c1']),
    ]);

    expect(pair3.candidate1, c1);
    expect(pair3.candidate2, c2);
    expect(pair3.firstOverSecond, 1);
    expect(pair3.secondOverFirst, 1);
    expect(pair3.ties, 1);
  });

  test('one ballot is cool', () {
    final b1 = RankedBallot([c1, c2]);
    final pair = CondorcetPair(c1, c2, [b1]);
    expect(pair.firstOverSecond, equals(1));
    expect(pair.secondOverFirst, equals(0));
  });

  test('two ballot is cool', () {
    final b1 = RankedBallot([c1, c2]);
    final b2 = RankedBallot([c1, c2]);
    final pair = CondorcetPair(c1, c2, [b1, b2]);
    expect(pair.firstOverSecond, equals(2));
    expect(pair.secondOverFirst, equals(0));
  });

  test('two ballot tie', () {
    final b1 = RankedBallot([c1, c2]);
    final b2 = RankedBallot([c2, c1]);
    final pair = CondorcetPair(c1, c2, [b1, b2]);
    expect(pair.firstOverSecond, equals(1));
    expect(pair.secondOverFirst, equals(1));
  });

  test('candidate normalization orders candidates', () {
    final pair = CondorcetPair(c2, c1);
    expect(pair.candidate1, c1);
    expect(pair.candidate2, c2);
  });

  test('null ballots constructor', () {
    final pair = CondorcetPair(c1, c2);
    expect(pair.candidate1, c1);
    expect(pair.candidate2, c2);
    expect(pair.firstOverSecond, isNull);
    expect(pair.secondOverFirst, isNull);
    expect(pair.ties, isNull);
  });

  group('winner and isTie', () {
    test('first candidate wins', () {
      final pair = CondorcetPair(c1, c2, [
        RankedBallot([c1, c2]),
      ]);
      expect(pair.winner, c1);
      expect(pair.isTie, isFalse);
    });

    test('second candidate wins', () {
      final pair = CondorcetPair(c1, c2, [
        RankedBallot([c2, c1]),
      ]);
      expect(pair.winner, c2);
      expect(pair.isTie, isFalse);
    });

    test('tie has no winner', () {
      final pair = CondorcetPair(c1, c2, [
        RankedBallot([c1, c2]),
        RankedBallot([c2, c1]),
      ]);
      expect(pair.winner, isNull);
      expect(pair.isTie, isTrue);
    });
  });

  group('matches', () {
    final pair = CondorcetPair(c1, c2);

    test('matches in order', () {
      expect(pair.matches(c1, c2), isTrue);
    });

    test('matches reverse order', () {
      expect(pair.matches(c2, c1), isTrue);
    });

    test('does not match different candidate', () {
      expect(pair.matches(c1, 'Can 3'), isFalse);
      expect(pair.matches('Can 3', c2), isFalse);
    });

    test('asserts on identical candidate', () {
      expect(() => pair.matches(c1, c1), throwsAssertionError);
    });
  });

  group('flip', () {
    test('flip with candidate1 returns identical instance', () {
      final pair = CondorcetPair(c1, c2, [
        RankedBallot([c1, c2]),
      ]);
      expect(pair.flip(c1), same(pair));
    });

    test('flip with candidate2 returns flipped instance', () {
      final pair = CondorcetPair(c1, c2, [
        RankedBallot([c1, c2]),
        RankedBallot([c1, c2]),
        RankedBallot([c2, c1]),
      ]);
      final flipped = pair.flip(c2);
      expect(flipped.candidate1, c2);
      expect(flipped.candidate2, c1);
      expect(flipped.firstOverSecond, 1);
      expect(flipped.secondOverFirst, 2);
      expect(flipped.ties, 0);
    });

    test('flip with non-member candidate asserts', () {
      final pair = CondorcetPair(c1, c2);
      expect(() => pair.flip('Can 3'), throwsAssertionError);
    });
  });

  group('equality and hashCode', () {
    test('equal pairs match', () {
      final pair1 = CondorcetPair(c1, c2);
      final pair2 = CondorcetPair(c2, c1);
      expect(pair1, equals(pair2));
      expect(pair1.hashCode, equals(pair2.hashCode));
    });

    test('different pairs do not match', () {
      final pair1 = CondorcetPair(c1, c2);
      final pair2 = CondorcetPair(c1, 'Can 3');
      expect(pair1, isNot(equals(pair2)));
    });
  });

  test('toString', () {
    final pair = CondorcetPair(c1, c2);
    expect(pair.toString(), '($c1, $c2)');
  });

  group('compareTo', () {
    test('compares by candidate1', () {
      final pairA = CondorcetPair('A', 'C');
      final pairB = CondorcetPair('B', 'C');
      expect(pairA.compareTo(pairB), isNegative);
      expect(pairB.compareTo(pairA), isPositive);
    });

    test('compares by candidate2 when candidate1 matches', () {
      final pairA = CondorcetPair('A', 'B');
      final pairB = CondorcetPair('A', 'C');
      expect(pairA.compareTo(pairB), isNegative);
      expect(pairB.compareTo(pairA), isPositive);
      expect(pairA.compareTo(pairA), isZero);
    });
  });
}
