#library('dartlib_test_map');

#import('../../../dartlib/vendor/unittest/unittest.dart');
#import('../../../dartlib/lib/core.dart');
#import('../../lib/vote.dart');
#import('../../lib/map.dart');

#source('test_distance_election.dart');
#source('test_spoiler_map.dart');
#source('test_location_data.dart');

void runMapTests() {
  group('map', () {
    TestDistanceElection.run();
    TestSpoilerMap.run();
    TestLocationData.run();
  });
}
