class TestMapElection {
  static void run() {
    var v1 = new MapPlayer(const Coordinate(1,1));
    var v2 = new MapPlayer(const Coordinate(-1, 1));
    var v3 = new MapPlayer(const Coordinate(-1, -1));
    var v4 = new MapPlayer(const Coordinate(1, -1));

    var c0 = new MapPlayer(const Coordinate());
    var c1 = new MapPlayer(const Coordinate(10,10));

    var ballots = MapElection.createBallots([v1,v2,v3,v4], [c0, c1]);

    test('MapElection.createBallots', (){
      expect(ballots, isNotNull);
      expect(ballots.length, equals(4));

      for(final b in ballots) {
        expect(b.choice, equals(c0));
        expect(b.rank.length, equals(2));
        expect(b.rank[0], equals(c0));
        expect(b.rank[1], equals(c1));
      }
    });

    test('PluralityElection', (){
      //
      // No votes for c0, so this isn't very exciting
      //
      var pluralityElection = new PluralityElection(ballots);
      expect(pluralityElection.singleWinner, equals(c0));
      expect(pluralityElection.places.length, equals(1));
      expect(pluralityElection.places[0].length, equals(1));
      expect(pluralityElection.places[0][0], equals(c0));
    });
  }
}
