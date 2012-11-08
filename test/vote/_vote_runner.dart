library vote_test;

import 'package:bot/test.dart';
import 'package:unittest/unittest.dart';
import '../../lib/vote.dart';

part 'test_plurality.dart';
part 'test_ranked_ballot.dart';
part 'test_condorcet.dart';
part 'test_condorcet_pair.dart';
part 'test_irv.dart';

void runVoteTests() {
  group('vote', (){
    TestPlurality.run();
    TestRankedBallot.run();
    TestCondorcetElection.run();
    TestCondorcetPair.run();
    TestIrv.run();
    test('majority threshold', (){
      expect(majorityThreshold(5), 3);
      expect(majorityThreshold(4), 3);
      expect(majorityThreshold(49), 25);
      expect(majorityThreshold(50), 26);
      expect(majorityThreshold(51), 26);
    });
  });
}
