import 'package:test/test.dart';
import 'package:vote/vote.dart';

import 'test_util.dart';

void main() {
  final v2 = 'voter2';
  final c1 = 'candidate 1';
  final c2 = 'candidate 2';

  test('no null voters', () {
    expect(() {
      RankedBallot(null, [c1]);
    }, throwsAssertionError);
  });

  test('no null candidates', () {
    expect(() {
      RankedBallot(v2, null);
    }, throwsAssertionError);
  });

  test('no empty candidates', () {
    expect(() {
      RankedBallot(v2, const []);
    }, throwsAssertionError);
  });

  test('no dupe candidates', () {
    expect(() {
      RankedBallot(v2, [c1, c1]);
    }, throwsAssertionError);
  });

  test('1 candidate is cool', () {
    RankedBallot(v2, [c1]);
  });

  test('2 candidates is cool', () {
    RankedBallot(v2, [c1, c2]);
  });
}
