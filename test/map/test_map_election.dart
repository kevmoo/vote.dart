class TestMapElection {
  static void run() {
    var v1 = new MapPlayer(const Coordinate(1,1));
    var v2 = new MapPlayer(const Coordinate(-1, 1));
    var v3 = new MapPlayer(const Coordinate(-1, -1));
    var v4 = new MapPlayer(const Coordinate(1, -1));
    var v5 = new MapPlayer(const Coordinate(9, 9));

    var c0 = new MapPlayer(const Coordinate());
    var c1 = new MapPlayer(const Coordinate(10,10));

    var ballots = MapElection.createBallots([v1,v2,v3,v4,v5], [c0, c1]);

    test('MapElection.createBallots', (){
      expect(ballots, isNotNull);
      expect(ballots.length, equals(5));

      for(final b in ballots.getRange(0, 4)) {
        expect(b.choice, equals(c0));
        expect(b.rank.length, equals(2));
        expect(b.rank[0], equals(c0));
        expect(b.rank[1], equals(c1));
      }

      expect(ballots[4].choice, equals(c1));
      expect(ballots[4].rank.length, equals(2));
      expect(ballots[4].rank[0], equals(c1));
      expect(ballots[4].rank[1], equals(c0));
    });

    test('PluralityElection', (){
      var pluralityElection = new PluralityElection(ballots);
      expect(pluralityElection.singleWinner, equals(c0));
      expect(pluralityElection.places.length, equals(2));
      expect(pluralityElection.places[0].length, equals(1));
      expect(pluralityElection.places[0][0], equals(c0));
      expect(pluralityElection.places[1].length, equals(1));
      expect(pluralityElection.places[1][0], equals(c1));
    });
  }
}
