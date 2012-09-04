#library('vote_test');

#import('package:unittest/unittest.dart');
#import('package:dartlib/lib/test.dart');
#import('../../lib/vote.dart');

#source('test_plurality.dart');
#source('test_ranked_ballot.dart');
#source('test_condorcet.dart');
#source('test_condorcet_pair.dart');
#source('test_irv.dart');

void runVoteTests() {
  group('vote', (){
    TestPlurality.run();
    TestRankedBallot.run();
    TestCondorcetElection.run();
    TestCondorcetPair.run();
    //TestIrv.run();
  });
}
