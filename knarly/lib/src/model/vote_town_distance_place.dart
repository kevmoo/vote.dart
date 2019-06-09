import 'package:collection/collection.dart';
import 'package:vote/vote.dart';

import 'sim.dart';
import 'vote_town.dart';

class VoteTownDistancePlace extends ElectionPlace<Sim<String>> {
  final double averageDistance;

  VoteTownDistancePlace._(
    this.averageDistance,
    int place,
    List<Sim<String>> candidates,
  ) : super(place, candidates);

  static List<VoteTownDistancePlace> create(VoteTown town) {
    final distances = Map<Sim<String>, double>.fromIterable(town.candidates,
        value: (candidate) =>
            town.voters
                .fold<double>(
                    0,
                    (value, voter) =>
                        value +
                        (voter.location - (candidate as Sim<String>).location)
                            .distance)
                .roundToDouble() /
            town.voters.length);

    final groups = groupBy(distances.keys, (key) => distances[key])
        .entries
        .toList(growable: false)
          ..sort((a, b) => a.key.compareTo(b.key));

    var place = 1;
    return groups.map((e) {
      final placeValue = place;
      place += e.value.length;
      return VoteTownDistancePlace._(e.key, placeValue, e.value);
    }).toList(growable: false);
  }
}
