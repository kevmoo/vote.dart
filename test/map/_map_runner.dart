library vote_test_map;

import 'package:bot/bot.dart';
import 'package:unittest/unittest.dart';
import 'package:vote/map.dart';
import 'package:vote/vote.dart';

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
