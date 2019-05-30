import 'package:test/test.dart';
import 'package:vote/src/ranked_ballot.dart';

void main() {
  group('ranked ballot', () {
    final v2 = "voter2";
    final c1 = "candidate 1";
    final c2 = "candidate 2";

    test('no null voters', () {
      expect(() {
        RankedBallot(null, [c1]);
      }, throwsArgumentError);
    });

    test('no null candidates', () {
      expect(() {
        RankedBallot(v2, null);
      }, throwsArgumentError);
    });

    test('no empty candidates', () {
      expect(() {
        RankedBallot(v2, []);
      }, throwsArgumentError);
    });

    test('no dupe candidates', () {
      expect(() {
        RankedBallot(v2, [c1, c1]);
      }, throwsArgumentError);
    });

    test('1 candidate is cool', () {
      RankedBallot(v2, [c1]);
    });

    test('2 candidates is cool', () {
      RankedBallot(v2, [c1, c2]);
    });
  });
}
