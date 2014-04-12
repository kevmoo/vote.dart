library console_test_harness;

import 'package:unittest/unittest.dart';
import 'calc/_calc_runner.dart';
import 'map/_map_runner.dart';
import 'vote/_vote_runner.dart';

void main() {
  groupSep = ' - ';

  runVoteTests();
  runMapTests();
  runCalcTests();
}
