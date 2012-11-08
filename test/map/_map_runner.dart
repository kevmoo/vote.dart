library vote_test_map;

import 'package:bot/bot.dart';
import 'package:unittest/unittest.dart';
import '../../lib/map.dart';
import '../../lib/vote.dart';

part 'test_distance_election.dart';
part 'test_spoiler_map.dart';
part 'test_location_data.dart';

void runMapTests() {
  group('map', () {
    TestDistanceElection.run();
    TestSpoilerMap.run();
    TestLocationData.run();
  });
}
