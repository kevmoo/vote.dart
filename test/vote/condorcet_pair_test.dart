import 'package:test/test.dart';
import 'package:vote/src/vote/condorcet_pair.dart';
import 'package:vote/src/vote/ranked_ballot.dart';

void main() {
  var c1 = "Can 1";
  var c2 = "Can 2";
  var v1 = "Voter 1";
  var v2 = "Voter 2";

  test('no dupe candidates', () {
    expect(() {
      CondorcetPair(c1, c1);
    }, throwsArgumentError);
  });

  test('no dupe ballots ~~ dupe voters', () {
    var b1 = RankedBallot(v1, [c1, c2]);
    var b2 = RankedBallot(v1, [c1, c2]);
    expect(() {
      CondorcetPair(c1, c2, [b1, b2]);
    }, throwsArgumentError);
  });

  test('must have a rank for both candidates', () {
    var b1 = RankedBallot(v1, [c1]);
    var b2 = RankedBallot(v1, [c2]);
    expect(() {
      CondorcetPair(c1, c2, [b1]);
    }, throwsArgumentError);
    expect(() {
      CondorcetPair(c1, c2, [b2]);
    }, throwsArgumentError);
  });

  test('one ballot is cool', () {
    var b1 = RankedBallot(v1, [c1, c2]);
    var pair = CondorcetPair(c1, c2, [b1]);
    expect(pair.firstOverSecond, equals(1));
    expect(pair.secondOverFirst, equals(0));
  });

  test('two ballot is cool', () {
    var b1 = RankedBallot(v1, [c1, c2]);
    var b2 = RankedBallot(v2, [c1, c2]);
    var pair = CondorcetPair(c1, c2, [b1, b2]);
    expect(pair.firstOverSecond, equals(2));
    expect(pair.secondOverFirst, equals(0));
  });

  test('two ballot tie', () {
    var b1 = RankedBallot(v1, [c1, c2]);
    var b2 = RankedBallot(v2, [c2, c1]);
    var pair = CondorcetPair(c1, c2, [b1, b2]);
    expect(pair.firstOverSecond, equals(1));
    expect(pair.secondOverFirst, equals(1));
  });
}
