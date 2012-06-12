#library('dartlib_test_vote');

#import('../../vendor/unittest/unittest.dart');
#import('../../lib/vote.dart');

void runVoteTests() {
  group('vote -- ', (){
    test('random vote test', randomVoteTest);
    test('Plurality Election Hates Double Votes', testPluralityElectionHatesDoubleVotes);
  });
}

void randomVoteTest(){
  var c1 = "candidate 1";

  var voters = new List<String>();
  for(num i = 0;i < 10; i++){
    voters.add("Voter ${i}");
  }

  print(voters);

  var ballots = voters.map((v) => new PluralityBallot(v, c1));

  print(ballots);

  var election = new PluralityElection(ballots);

  print(election.voters);
  print(election.ballots);
}

void testPluralityElectionHatesDoubleVotes(){
  var c1 = "candidate 1";

  var voter = "Bad Voter";
  var voters = [voter, voter];


  var ballots = new List.from(voters.map((v) => new PluralityBallot(v, c1)));

  bool exception = false;
  try {
    var election = new PluralityElection(ballots);
  }
  catch(final e) {
    exception = true;
  }
  expect(exception).isTrue();

}
