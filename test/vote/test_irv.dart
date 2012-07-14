class TestIrv {
  static void run() {
    group('IrvElection', () {
      test('one candidate', _testOneCandidate);
      test('two candidates', _testTwoCandidatesObvious);
      test('two candidates, tied', _testTwoCandidatesTied);
      test('three candidates, tied', _threeWayTieForFirst);
      test('Ice Cream', _testIceCream);
    });
  }

  static void _testOneCandidate() {
    var c = "Candidate 1";
    var v = "Voter 1";
    var b = new RankedBallot(v, [c]);

    var ce = new IrvElection([b]);

    expect(ce, isNotNull);
    expect(ce.singleWinner, equals(c));
    expect(ce.candidates, unorderedEquals([c]));
    expect(ce.ballots, unorderedEquals([b]));
    expect(ce.places.length, equals(1));

    var first = ce.places[0];
    expect(first, unorderedEquals([c]));
  }

  static void _testTwoCandidatesObvious() {

  }

  static void _testTwoCandidatesTied() {

  }

  static void _testIceCream() {
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

    var ce = new IrvElection(ballots);

    expect(ce, isNotNull);
    expect(ce.singleWinner, equals(canC));
    expect(ce.candidates, unorderedEquals([canC, canCC, canVan]));
    expect(ce.ballots, unorderedEquals(ballots));

    expect(ce.places.length, equals(3));

    expect(ce.places[0].place, equals(1));
    expect(ce.places[0], unorderedEquals([canC]));

    expect(ce.places[1].place, equals(2));
    expect(ce.places[1], unorderedEquals([canCC]));

    expect(ce.places[2].place, equals(3));
    expect(ce.places[2], unorderedEquals([canVan]));
  }

  static void _threeWayTieForFirst() {
    // 1st, 4th, 5th, 7th
    // 3,   1,   2,   1
    var cA1 = "A1";
    var cA2 = "A2";
    var cA3 = "A3";
    var cB1 = "B1";
    var cC1 = "C1";
    var cC2 = "C2";
    var cD1 = "D1";

    var voter = 1;

    var ballots = new List<RankedBallot>();

    ballots.add(new RankedBallot("Voter ${voter++}", [cA1, cA2, cA3, cB1, cC1, cC2, cD1]));
    ballots.add(new RankedBallot("Voter ${voter++}", [cA1, cA2, cA3, cB1, cC2, cC1, cD1]));
    ballots.add(new RankedBallot("Voter ${voter++}", [cA2, cA3, cA1, cB1, cC1, cC2, cD1]));
    ballots.add(new RankedBallot("Voter ${voter++}", [cA2, cA3, cA1, cB1, cC2, cC1, cD1]));
    ballots.add(new RankedBallot("Voter ${voter++}", [cA3, cA1, cA2, cB1, cC1, cC2, cD1]));
    ballots.add(new RankedBallot("Voter ${voter++}", [cA3, cA1, cA2, cB1, cC2, cC1, cD1]));


    var ce = new IrvElection(ballots);

  }
}
