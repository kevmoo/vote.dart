import 'package:test/test.dart';
import 'package:vote/vote.dart';

import 'test_util.dart';

void main() {
  final c1 = 'candidate 1';
  final c2 = 'candidate 2';

  test('no empty candidates', () {
    expect(
      () {
        RankedBallot<int>(const []);
      },
      throwsAssertionError,
    );
  });

  test('no dupe candidates', () {
    expect(
      () {
        RankedBallot([c1, c1]);
      },
      throwsAssertionError,
    );
  });

  test('1 candidate is cool', () {
    RankedBallot([c1]);
  });

  test('2 candidates is cool', () {
    RankedBallot([c1, c2]);
  });

  test('compare', () {
    void expectLess(List<String> a, List<String> b) {
      final rbA = RankedBallot(a);
      final rbB = RankedBallot(b);
      expect(rbA.compareTo(rbB), lessThan(0));
      expect(rbB.compareTo(rbA), greaterThan(0));
      expect(rbA.compareTo(rbA), 0);
      expect(rbB.compareTo(rbB), 0);
      expect(rbA, equals(RankedBallot(a.toList())));
      expect(rbA, isNot(equals(RankedBallot(b.toList()))));
      expect(rbB, equals(RankedBallot(b.toList())));
      expect(rbB, isNot(equals(RankedBallot(a.toList()))));
    }

    expectLess([c1], [c2]);
    expectLess([c1, c2], [c2]);
    expectLess([c1], [c1, c2]);
    expectLess([c1, c2], [c2, c1]);
  });
}
