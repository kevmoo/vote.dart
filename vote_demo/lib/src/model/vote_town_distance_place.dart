import 'package:collection/collection.dart';
import 'package:vote/vote.dart';

import 'town_folk.dart';
import 'vote_town.dart';

class VoteTownDistancePlace._(
  final double averageDistance,
  super.place,
  super.candidates,
) extends ElectionPlace<TownCandidate> {
  static List<VoteTownDistancePlace> create(VoteTown town) {
    final distances = Map<TownCandidate, double>.fromIterable(
      town.candidates,
      value: (candidate) =>
          averageVoterDistanceTo(town, (candidate as TownCandidate).location),
    );

    final groups = groupBy(
      distances.keys,
      (key) => distances[key],
    ).entries.toList(growable: false)..sort((a, b) => a.key!.compareTo(b.key!));

    var place = 1;
    return groups
        .map((e) {
          final placeValue = place;
          place += e.value.length;
          return VoteTownDistancePlace._(e.key!, placeValue, e.value);
        })
        .toList(growable: false);
  }
}
