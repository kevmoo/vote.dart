#library('dartlib_test_vote');

#import('../../../dartlib/vendor/unittest/unittest.dart');
#import('../../lib/vote.dart');
#source('test_plurality.dart');
#source('test_ranked_ballot.dart');
#source('test_condorcet.dart');

void runVoteTests() {
  group('vote', (){
    TestPlurality.run();
    TestRankedBallot.run();
    TestCondorcetElection.run();
  });
}
