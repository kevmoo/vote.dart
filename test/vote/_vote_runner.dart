library vote_test;

import 'package:bot_test/bot_test.dart';
import 'package:unittest/unittest.dart';
import 'package:vote/vote.dart';

import 'irv_test.dart' as irv;

part 'test_plurality.dart';
part 'test_ranked_ballot.dart';
part 'test_condorcet.dart';
part 'test_condorcet_pair.dart';

void main() {
  TestPlurality.run();
  TestRankedBallot.run();
  TestCondorcetElection.run();
  TestCondorcetPair.run();
  irv.main();
  test('majority threshold', () {
    expect(majorityThreshold(5), 3);
    expect(majorityThreshold(4), 3);
    expect(majorityThreshold(49), 25);
    expect(majorityThreshold(50), 26);
    expect(majorityThreshold(51), 26);
  });
}
