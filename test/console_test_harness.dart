library console_test_harness;

import 'package:unittest/unittest.dart';
import 'package:unittest/vm_config.dart';
import 'calc/_calc_runner.dart';
import 'map/_map_runner.dart';
import 'vote/_vote_runner.dart';

main() {
  final config = new VMConfiguration();
  testCore(config);
}

void testCore(Configuration config) {
  configure(config);
  groupSep = ' - ';

  runVoteTests();
  runMapTests();
  runCalcTests();
}
