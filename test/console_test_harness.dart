#import('package:unittest/vm_config.dart');

#import('vote/_vote_runner.dart');
#import('map/_map_runner.dart');
#import('calc/_calc_runner.dart');

main() {
  useVmConfiguration();

  runVoteTests();
  runMapTests();
  runCalcTests();
}
