#!/usr/bin/env dart

#import('../../dartlib/vendor/unittest/vm_config.dart');

#import('vote/_vote_runner.dart');
#import('map/_map_runner.dart');

main() {
  useVmConfiguration();

  runVoteTests();
  runMapTests();
}
