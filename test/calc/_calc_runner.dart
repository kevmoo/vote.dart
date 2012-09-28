#library('vote_test_calc');

#import('package:unittest/unittest.dart');
#import('package:bot/bot.dart');
#import('../../lib/calc.dart');
#import('../../lib/vote.dart');
#import('../../lib/map.dart');

#source('test_calc_engine.dart');

void runCalcTests() {
  group('calc', () {
    TestCalcEngine.run();
  });
}
