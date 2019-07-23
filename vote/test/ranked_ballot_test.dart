import 'package:test/test.dart';
import 'package:vote/vote.dart';

import 'test_util.dart';

void main() {
  final c1 = 'candidate 1';
  final c2 = 'candidate 2';

  test('no null candidates', () {
    expect(() {
      RankedBallot(null);
    }, throwsAssertionError);
  });

  test('no empty candidates', () {
    expect(() {
      RankedBallot(const []);
    }, throwsAssertionError);
  });

  test('no dupe candidates', () {
    expect(() {
      RankedBallot([c1, c1]);
    }, throwsAssertionError);
  });

  test('1 candidate is cool', () {
    RankedBallot([c1]);
  });

  test('2 candidates is cool', () {
    RankedBallot([c1, c2]);
  });
}
