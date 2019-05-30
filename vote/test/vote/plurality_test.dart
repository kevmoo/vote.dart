import 'package:test/test.dart';
import 'package:vote/src/plurality_ballot.dart';
import 'package:vote/src/plurality_election.dart';

void main() {
  test('random vote test', randomVoteTest);
  test('Plurality Election Hates Double Votes',
      testPluralityElectionHatesDoubleVotes);
  test('tied for 1st', testTiedforFirst);
  test('single vote, single winner', testSingleVoteSingleWinner);
}

void randomVoteTest() {
  var c1 = "candidate 1";

  var voters = List<String>();
  for (num i = 0; i < 10; i++) {
    voters.add("Voter $i");
  }

  var ballots = voters.map((v) => PluralityBallot(v, c1)).toList();

  PluralityElection(ballots);
}

void testSingleVoteSingleWinner() {
  var c1 = "candidate 1";

  var voter = "Bad Voter";
  var voters = [voter];

  var ballots = List<PluralityBallot>.from(
      voters.map((v) => PluralityBallot(v, c1)).toList());

  var election = PluralityElection(ballots);
  expect(election.singleWinner, equals(c1));
  expect(election.places.length, equals(1));
  var firstPlace = election.places[0];
  expect(firstPlace.length, equals(1));
  expect(firstPlace[0], equals(c1));
}

void testTiedforFirst() {
  var c1 = "candidate 1";
  var c2 = "candidate 2";
  var c3 = "candidate 3";

  var voters = List<String>();
  for (num i = 0; i < 10; i++) {
    voters.add("c1 Voter $i");
  }

  var ballots = List<PluralityBallot>();

  ballots.addAll(voters.map((v) => PluralityBallot(v, c1)).toList());

  voters = List<String>();
  for (num i = 0; i < 10; i++) {
    voters.add("c2 Voter ${voters.length}");
  }

  ballots.addAll(voters.map((v) => PluralityBallot(v, c2)).toList());

  voters = List<String>();
  for (num i = 0; i < 9; i++) {
    voters.add("c3 Voter ${voters.length}");
  }

  ballots.addAll(voters.map((v) => PluralityBallot(v, c3)).toList());

  var election = PluralityElection(ballots);
  expect(election.singleWinner, isNull);
  expect(election.places.length, equals(2));

  var firstPlace = election.places[0];
  expect(firstPlace.place, equals(1));
  expect(firstPlace.length, equals(2));

  var thirdPlace = election.places[1];
  expect(thirdPlace.place, equals(3));
  expect(thirdPlace.length, equals(1));
  expect(thirdPlace[0], equals(c3));
}

void testPluralityElectionHatesDoubleVotes() {
  var c1 = "candidate 1";

  var voter = "Bad Voter";
  var voters = [voter, voter];

  var ballots = List<PluralityBallot>.from(
      voters.map((v) => PluralityBallot(v, c1)).toList());

  expect(() {
    PluralityElection(ballots);
  }, throwsArgumentError);
}
