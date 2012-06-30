class TestCondorcetElection {
  static void run() {
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
    expect(ce.candidates, someElement(equals(c)));
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
    expect(ce.candidates, someElement(equals(canC)));
    expect(ce.candidates, someElement(equals(canCC)));
    expect(ce.candidates, someElement(equals(canVan)));
  }
}
