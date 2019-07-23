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

  test('must have a rank for both candidates', () {
    final b1 = RankedBallot([c1]);
    final b2 = RankedBallot([c2]);
    expect(() {
      CondorcetPair(c1, c2, [b1]);
    }, throwsAssertionError);

    expect(() {
      CondorcetPair(c1, c2, [b2]);
    }, throwsAssertionError);
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
