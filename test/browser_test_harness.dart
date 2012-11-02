import 'package:unittest/unittest.dart';
import 'package:unittest/html_enhanced_config.dart';

import 'vote/_vote_runner.dart';
import 'map/_map_runner.dart';
import 'calc/_calc_runner.dart';

main() {
  groupSep = ' - ';
  useHtmlEnhancedConfiguration();

  runVoteTests();
  runMapTests();
  runCalcTests();
}
