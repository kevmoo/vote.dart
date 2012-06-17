#library('dartlib_test_vote');

#import('../../vendor/unittest/unittest.dart');
#import('../../lib/vote.dart');
#source('test_plurality.dart');

void runVoteTests() {
  group('vote', (){
    TestPlurality.run();
  });
}
