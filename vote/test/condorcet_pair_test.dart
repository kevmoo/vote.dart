import 'package:test/test.dart';
import 'package:vote/vote.dart';

void main() {
  final c1 = "Can 1";
  final c2 = "Can 2";
  final v1 = "Voter 1";
  final v2 = "Voter 2";

  test('no dupe candidates', () {
    expect(() {
      CondorcetPair(c1, c1);
    }, throwsArgumentError);
  });

  test('no dupe ballots ~~ dupe voters', () {
    final b1 = RankedBallot(v1, [c1, c2]);
    final b2 = RankedBallot(v1, [c1, c2]);
    expect(() {
      CondorcetPair(c1, c2, [b1, b2]);
    }, throwsArgumentError);
  });

  test('must have a rank for both candidates', () {
    final b1 = RankedBallot(v1, [c1]);
    final b2 = RankedBallot(v1, [c2]);
    expect(() {
      CondorcetPair(c1, c2, [b1]);
    }, throwsArgumentError);
    expect(() {
      CondorcetPair(c1, c2, [b2]);
    }, throwsArgumentError);
  });

  test('one ballot is cool', () {
    final b1 = RankedBallot(v1, [c1, c2]);
    final pair = CondorcetPair(c1, c2, [b1]);
    expect(pair.firstOverSecond, equals(1));
    expect(pair.secondOverFirst, equals(0));
  });

  test('two ballot is cool', () {
    final b1 = RankedBallot(v1, [c1, c2]);
    final b2 = RankedBallot(v2, [c1, c2]);
    final pair = CondorcetPair(c1, c2, [b1, b2]);
    expect(pair.firstOverSecond, equals(2));
    expect(pair.secondOverFirst, equals(0));
  });

  test('two ballot tie', () {
    final b1 = RankedBallot(v1, [c1, c2]);
    final b2 = RankedBallot(v2, [c2, c1]);
    final pair = CondorcetPair(c1, c2, [b1, b2]);
    expect(pair.firstOverSecond, equals(1));
    expect(pair.secondOverFirst, equals(1));
  });
}
