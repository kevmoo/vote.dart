import 'package:test/test.dart';
import 'package:vote/vote.dart';

void main() {
  test('random vote test', () {
    final c1 = "candidate 1";

    final ballots = [
      for (num i = 0; i < 10; i++) PluralityBallot("Voter $i", c1),
    ];

    PluralityElection(ballots);
  });

  test('Plurality Election Hates Double Votes', () {
    final c1 = "candidate 1";

    final voter = "Bad Voter";
    final voters = [voter, voter];

    final ballots = voters.map((v) => PluralityBallot(v, c1)).toList();

    expect(() {
      PluralityElection(ballots);
    }, throwsArgumentError);
  });

  test('tied for 1st', () {
    final c1 = "candidate 1";
    final c2 = "candidate 2";
    final c3 = "candidate 3";

    var voters = <String>[];
    for (num i = 0; i < 10; i++) {
      voters.add("c1 Voter $i");
    }

    final ballots = voters.map((v) => PluralityBallot(v, c1)).toList();

    voters = <String>[];
    for (num i = 0; i < 10; i++) {
      voters.add("c2 Voter ${voters.length}");
    }

    ballots.addAll(voters.map((v) => PluralityBallot(v, c2)).toList());

    voters = <String>[];
    for (num i = 0; i < 9; i++) {
      voters.add("c3 Voter ${voters.length}");
    }

    ballots.addAll(voters.map((v) => PluralityBallot(v, c3)).toList());

    final election = PluralityElection(ballots);
    expect(election.singleWinner, isNull);
    expect(election.places.length, equals(2));

    final firstPlace = election.places[0];
    expect(firstPlace.place, equals(1));
    expect(firstPlace.length, equals(2));

    final thirdPlace = election.places[1];
    expect(thirdPlace.place, equals(3));
    expect(thirdPlace.length, equals(1));
    expect(thirdPlace[0], equals(c3));
  });

  test('single vote, single winner', () {
    final c1 = "candidate 1";

    final voter = "Bad Voter";
    final voters = [voter];

    final ballots = voters.map((v) => PluralityBallot(v, c1)).toList();

    final election = PluralityElection(ballots);
    expect(election.singleWinner, equals(c1));
    expect(election.places.length, equals(1));

    final firstPlace = election.places[0];
    expect(firstPlace.length, equals(1));
    expect(firstPlace[0], equals(c1));
  });
}
