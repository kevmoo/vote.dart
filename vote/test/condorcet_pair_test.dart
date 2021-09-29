import 'package:test/test.dart';
import 'package:vote/vote.dart';

import 'test_util.dart';

void main() {
  final c1 = 'Can 1';
  final c2 = 'Can 2';

  test('no dupe candidates', () {
    expect(
      () {
        CondorcetPair(c1, c1);
      },
      throwsAssertionError,
    );
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
}
