part of vote_test_map;

class TestDistanceElection {
  static void run() {
    group('DistanceElection', (){
      _testSimpleElection();
      test('tie', _testTie);
    });
  }

  static void _testTie() {
    var voters = new List<MapPlayer>();
    for(int i = -2; i <= 2; i++) {
      for(int j = -2; j <= 2; j++) {
        voters.add(new MapPlayer(new Coordinate(i,j)));
      }
    }

    var c0 = new MapPlayer(const Coordinate(-1, 0));
    var c1 = new MapPlayer(const Coordinate(1, 0));

    var mapElection = new DistanceElection(voters, [c0, c1]);

    expect(mapElection.singleWinner, isNull);
    expect(mapElection.places.length, equals(1));
    expect(mapElection.places[0].length, equals(2));
    expect(mapElection.places[0], unorderedEquals([c0, c1]));
  }

  static void _testSimpleElection() {
    var v1 = new MapPlayer(const Coordinate(1,1));
    var v2 = new MapPlayer(const Coordinate(-1, 1));
    var v3 = new MapPlayer(const Coordinate(-1, -1));
    var v4 = new MapPlayer(const Coordinate(1, -1));
    var v5 = new MapPlayer(const Coordinate(9, 9));

    var c0 = new MapPlayer(const Coordinate());
    var c1 = new MapPlayer(const Coordinate(10,10));

    final mapElection = new DistanceElection([v1,v2,v3,v4,v5], [c0, c1]);
    final ballots = mapElection.ballots;

    group('simple, obvious map', () {
      test('ballots', (){
        expect(ballots, isNotNull);
        expect(ballots.length, equals(5));

        for(final b in ballots.take(4).toList()) {
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

      test('singleWinner', () {
        expect(mapElection.singleWinner, equals(c0));
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

      test('CondorcetElection', () {
        var condorcetElection = new CondorcetElection(ballots);
        expect(condorcetElection.singleWinner, equals(c0));
        expect(condorcetElection.places.length, equals(2));
        expect(condorcetElection.places[0].length, equals(1));
        expect(condorcetElection.places[0][0], equals(c0));
        expect(condorcetElection.places[1].length, equals(1));
        expect(condorcetElection.places[1][0], equals(c1));
      });
    });
  }
}
