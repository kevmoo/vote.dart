#library('dartlib_test_vote');

#import('../../../dartlib/vendor/unittest/unittest.dart');
#import('../../lib/vote.dart');
#import('../../../dartlib/lib/test.dart');

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
