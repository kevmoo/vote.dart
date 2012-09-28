class TestCondorcetPair {
  static void run() {
    group('CondorcetPair', () {
      var c1 = "Can 1";
      var c2 = "Can 2";
      var v1 = "Voter 1";
      var v2 = "Voter 2";

      test('no dupe candidates', () {
        expect((){ var pair = new CondorcetPair(c1, c1); }, throwsArgumentError);
      });

      test('no dupe ballots ~~ dupe voters', () {
        var b1 = new RankedBallot(v1, [c1, c2]);
        var b2 = new RankedBallot(v1, [c1, c2]);
        expect((){ var pair = new CondorcetPair(c1, c2, [b1, b2]); }, throwsArgumentError);
      });

      test('must have a rank for both candidates', () {
        var b1 = new RankedBallot(v1, [c1]);
        var b2 = new RankedBallot(v1, [c2]);
        expect((){ var pair = new CondorcetPair(c1, c2, [b1]); }, throwsArgumentError);
        expect((){ var pair = new CondorcetPair(c1, c2, [b2]); }, throwsArgumentError);
      });

      test('one ballot is cool', () {
        var b1 = new RankedBallot(v1, [c1, c2]);
        var pair = new CondorcetPair(c1, c2, [b1]);
        expect(pair.firstOverSecond, equals(1));
        expect(pair.secondOverFirst, equals(0));
      });

      test('two ballot is cool', () {
        var b1 = new RankedBallot(v1, [c1, c2]);
        var b2 = new RankedBallot(v2, [c1, c2]);
        var pair = new CondorcetPair(c1, c2, [b1, b2]);
        expect(pair.firstOverSecond, equals(2));
        expect(pair.secondOverFirst, equals(0));
      });

      test('two ballot tie', () {
        var b1 = new RankedBallot(v1, [c1, c2]);
        var b2 = new RankedBallot(v2, [c2, c1]);
        var pair = new CondorcetPair(c1, c2, [b1, b2]);
        expect(pair.firstOverSecond, equals(1));
        expect(pair.secondOverFirst, equals(1));
      });

    });
  }
}
