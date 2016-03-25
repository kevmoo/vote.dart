import 'package:bot/bot.dart' hide ReadOnlyCollection;

import '../vote/ranked_ballot.dart';
import 'map_player.dart';

class DistanceBallot extends RankedBallot<MapPlayer, MapPlayer> {
  final Map<MapPlayer, num> _distances;

  DistanceBallot._internal(
      MapPlayer voter, List<MapPlayer> items, this._distances)
      : super.protected(voter, items);

  factory DistanceBallot(MapPlayer voter, Iterable<MapPlayer> candidates) {
    final distances = $(candidates).toMap((c) {
      var d = voter.location.distanceTo(c.location);
      return (d * 128).toInt() / 128;
    });

    var rank = new List<MapPlayer>.from(candidates);
    requireArgument(rank.length > 0, 'candidates');
    requireArgument(CollectionUtil.allUnique(rank), 'candidates');
    rank.sort((a, b) {
      var d = distances[a].compareTo(distances[b]);
      if (d == 0) {
        // ensure ranking of tied candidates is random-ish
        d = rnd.nextBool() ? -1 : 1;
      }
      return d;
    });

    var items = new List<MapPlayer>.unmodifiable(rank);

    return new DistanceBallot._internal(voter, items, distances);
  }

  num getDistance(MapPlayer candidate) {
    return _distances[candidate];
  }
}
