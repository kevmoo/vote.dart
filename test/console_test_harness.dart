#!/usr/bin/env dart --enable_type_checks --enable_asserts

#import('../../dartlib/vendor/unittest/vm_config.dart');

#import('vote/_vote_runner.dart');
#import('map/_map_runner.dart');

main() {
  useVmConfiguration();

  runVoteTests();
  runMapTests();
}
