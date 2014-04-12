library console_test_harness;

import 'package:unittest/unittest.dart';

import 'calc/_calc_runner.dart' as calc;
import 'map/_map_runner.dart' as map;
import 'vote/_vote_runner.dart' as vote;

void main() {
  groupSep = ' - ';

  group('calc', calc.main);
  group('map', map.main);
  group('vote_runner', vote.main);
}
