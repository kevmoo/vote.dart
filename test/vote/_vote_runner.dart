#library('vote_test');

#import('package:unittest/unittest.dart');
#import('package:bot/test.dart');
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
    test('majority threshold', (){
      expect(majorityThreshold(5), 3);
      expect(majorityThreshold(4), 3);
      expect(majorityThreshold(49), 25);
      expect(majorityThreshold(50), 26);
      expect(majorityThreshold(51), 26);
    });
  });
}
