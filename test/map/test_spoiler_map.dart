part of vote_test_map;

class TestSpoilerMap {
  final MapPlayer canCenter, canLeft, canSpoiler;
  DistanceElection mapElection;

  TestSpoilerMap() :
    this.canCenter = new MapPlayer(const Coordinate(5, 0)),
    this.canLeft = new MapPlayer(const Coordinate(4, 0)),
    this.canSpoiler = new MapPlayer(const Coordinate(7.1, 0)) {
    // 11 voters from 0,0 to 10,0
    var voters = new List<MapPlayer>();
    for(var i = 0; i <= 10; i++) {
      voters.add(new MapPlayer(new Coordinate(i,0)));
    }

    mapElection = new DistanceElection(voters, [canCenter, canLeft, canSpoiler]);
  }

  static void run() {

    group('spoiler', () {
      test('PluralityElection', (){
        var test = new TestSpoilerMap();

        var election = new PluralityElection(test.mapElection.ballots);
        expect(election.singleWinner, equals(test.canLeft));
        expect(election.places.length, equals(3));
        expect(election.places[0].length, equals(1));
        expect(election.places[0][0], equals(test.canLeft));
        expect(election.places[1].length, equals(1));
        expect(election.places[1][0], equals(test.canSpoiler));
        expect(election.places[2].length, equals(1));
        expect(election.places[2][0], equals(test.canCenter));
      });

      test('CondorcetElection', (){
        var test = new TestSpoilerMap();

        var election = new CondorcetElection(test.mapElection.ballots);
        expect(election.singleWinner, equals(test.canCenter));
        expect(election.places.length, equals(3));
        expect(election.places[0].length, equals(1));
        expect(election.places[0][0], equals(test.canCenter));
        expect(election.places[1].length, equals(1));
        expect(election.places[1][0], equals(test.canLeft));
        expect(election.places[2].length, equals(1));
        expect(election.places[2][0], equals(test.canSpoiler));
      });
    });
  }
}
