import 'package:collection/collection.dart';
import 'package:vote/vote.dart';

import 'town_folk.dart';
import 'vote_town.dart';

class VoteTownDistancePlace extends ElectionPlace<TownCandidate> {
  final double averageDistance;

  VoteTownDistancePlace._(
    this.averageDistance,
    int place,
    List<TownCandidate> candidates,
  ) : super(place, candidates);

  static List<VoteTownDistancePlace> create(VoteTown town) {
    final distances = Map<TownCandidate, double>.fromIterable(
      town.candidates,
      value: (candidate) => averageVoterDistanceTo(
        town,
        (candidate as TownCandidate).location,
      ),
    );

    final groups = groupBy(distances.keys, (key) => distances[key])
        .entries
        .toList(growable: false)
      ..sort((a, b) => a.key!.compareTo(b.key!));

    var place = 1;
    return groups.map((e) {
      final placeValue = place;
      place += e.value.length;
      return VoteTownDistancePlace._(e.key!, placeValue, e.value);
    }).toList(growable: false);
  }
}
