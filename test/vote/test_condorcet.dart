class TestCondorcetElection {
  static void run() {
    group('CondorcetPair', () {
      var c1 = "Can 1";
      var c2 = "Can 2";
      var v1 = "Voter 1";
      var v2 = "Voter 2";

      test('no dupe candidates', () {
        expect((){ var pair = new CondorcetPair(c1, c1); }, throwsIllegalArgumentException);
      });

      test('no dupe ballots ~~ dupe voters', () {
        var b1 = new RankedBallot(v1, [c1, c2]);
        var b2 = new RankedBallot(v1, [c1, c2]);
        expect((){ var pair = new CondorcetPair(c1, c2, [b1, b2]); }, throwsIllegalArgumentException);
      });

      test('must have a rank for both candidates', () {
        var b1 = new RankedBallot(v1, [c1]);
        var b2 = new RankedBallot(v1, [c2]);
        expect((){ var pair = new CondorcetPair(c1, c2, [b1]); }, throwsIllegalArgumentException);
        expect((){ var pair = new CondorcetPair(c1, c2, [b2]); }, throwsIllegalArgumentException);
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
    group('CondorcetElection', (){
      test('simple', _sample1);
      test('ice cream', _sample2);
    });
  }

  static void _sample1() {
    var c = "Candidate 1";
    var v = "Voter 1";
    var b = new RankedBallot(v, [c]);

    var ce = new CondorcetElection([b]);

    expect(ce, isNotNull);
    expect(ce.singleWinner, equals(c));


    // 1 place, 1 single winner,
  }

  static void _sample2() {
    var canC = "Chocolate";
    var canCC = "Chocolate Chunk";
    var canVan = "Vanilla";

    var voter = 1;

    var ballots = new List<RankedBallot>();

    // 29 cc, c, v
    for(var i=0;i<29;i++) {
      ballots.add(new RankedBallot("Voter ${voter++}", [canCC, canC, canVan]));
    }

    // 31 c, cc, v
    for(var i=0;i<31;i++) {
      ballots.add(new RankedBallot("Voter ${voter++}", [canC, canCC, canVan]));
    }

    // 40 v, c, cc
    for(var i=0;i<40;i++) {
      ballots.add(new RankedBallot("Voter ${voter++}", [canVan, canC, canCC]));
    }

    var ce = new CondorcetElection(ballots);

    expect(ce, isNotNull);
    expect(ce.singleWinner, equals(canC));
  }
}
