class TestSpoilerMap {
  static void run() {
    // 11 voters from 0,0 to 10,0
    var voters = new List<MapPlayer>();
    for(var i = 0; i <= 10; i++) {
      voters.add(new MapPlayer(new Coordinate(i,0)));
    }

    // center at 5
    var canCenter = new MapPlayer(const Coordinate(5, 0));

    // left at 4
    var canLeft = new MapPlayer(const Coordinate(4, 0));

    // spoiler at 7
    var canSpoiler = new MapPlayer(const Coordinate(7, 0));

    final mapElection = new MapElection(voters, [canCenter, canLeft, canSpoiler]);
    final ballots = mapElection.ballots;

    group('spoiler map', () {
      test('PluralityElection', (){
        var election = new PluralityElection(ballots);
        expect(election.singleWinner, equals(canLeft));
        expect(election.places.length, equals(3));
        expect(election.places[0].length, equals(1));
        expect(election.places[0][0], equals(canLeft));
        expect(election.places[1].length, equals(1));
        expect(election.places[1][0], equals(canSpoiler));
        expect(election.places[2].length, equals(1));
        expect(election.places[2][0], equals(canCenter));
      });

      test('CondorcetElection', (){
        var election = new CondorcetElection(ballots);
        expect(election.singleWinner, equals(canCenter));
        expect(election.places.length, equals(3));
        expect(election.places[0].length, equals(1));
        expect(election.places[0][0], equals(canCenter));
        expect(election.places[1].length, equals(1));
        expect(election.places[1][0], equals(canLeft));
        expect(election.places[2].length, equals(1));
        expect(election.places[2][0], equals(canSpoiler));
      });
    });
  }
}
