#!/usr/bin/env dart --enable_type_checks --enable_asserts

#import('package:unittest/vm_config.dart');

#import('test/vote/_vote_runner.dart');
#import('test/map/_map_runner.dart');

main() {
  useVmConfiguration();

  runVoteTests();
  runMapTests();
}
