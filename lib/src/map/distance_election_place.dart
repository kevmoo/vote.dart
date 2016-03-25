import '../vote/election_place.dart';
import 'map_player.dart';

class DistanceElectionPlace extends ElectionPlace {
  final num avgDistance;
  final num avgDistanceSquared;

  DistanceElectionPlace(int place, Iterable<MapPlayer> candidates,
      this.avgDistance, this.avgDistanceSquared)
      : super(place, candidates);
}
