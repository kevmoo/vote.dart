#library('dartlib_test_map');

#import('../../../dartlib/vendor/unittest/unittest.dart');
#import('../../../dartlib/lib/core.dart');
#import('../../lib/vote.dart');
#import('../../lib/map.dart');

#source('test_map_election.dart');

void runMapTests() {
  group('simple, obvious map', (){
    TestMapElection.run();
  });
}
