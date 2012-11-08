library vote_test_calc;

import 'package:bot/bot.dart';
import 'package:unittest/unittest.dart';
import '../../lib/calc.dart';
import '../../lib/map.dart';
import '../../lib/vote.dart';

part 'test_calc_engine.dart';

void runCalcTests() {
  group('calc', () {
    TestCalcEngine.run();
  });
}
