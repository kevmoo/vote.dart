#library('dartlib_test_vote');

#import('../../vendor/unittest/unittest.dart');
#import('../../lib/vote.dart');

void runVoteTests() {
  group('vote -- ', (){
    test('random vote test', randomVoteTest);
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
