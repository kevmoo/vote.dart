#library('dartlib_test_map');

#import('../../../dartlib/vendor/unittest/unittest.dart');
#import('../../../dartlib/lib/core.dart');
#import('../../lib/vote.dart');
#import('../../lib/map.dart');

#source('test_distance_election.dart');
#source('test_spoiler_map.dart');

void runMapTests() {
  TestDistanceElection.run();
  TestSpoilerMap.run();
}
