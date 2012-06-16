#!/usr/bin/env dart

#import('../vendor/unittest/vm_config.dart');

#import('core/_core_runner.dart');
#import('vote/_vote_runner.dart');

main() {
  useVmConfiguration();

  runCoreTests();
  runVoteTests();
}
