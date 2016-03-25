import 'package:bot/bot.dart' hide ReadOnlyCollection;

import '../vote/election.dart';
import 'distance_ballot.dart';
import 'distance_election_place.dart';
import 'location_data.dart';
import 'map_player.dart';

class DistanceElection extends Election {
  @override
  final List<MapPlayer> candidates;

  @override
  final List<DistanceBallot> ballots;

  @override
  final List<DistanceElectionPlace> places;

  DistanceElection._internal(this.candidates, this.ballots, this.places);

  factory DistanceElection.fromData(LocationData data) {
    return new DistanceElection(data.voters, data.candidates);
  }

  factory DistanceElection(
      Iterable<MapPlayer> voters, Iterable<MapPlayer> candidates) {
    final cans = new List<MapPlayer>.unmodifiable(candidates);

    final ballots = new List<DistanceBallot>.unmodifiable(
        voters.map((voter) => new DistanceBallot(voter, cans)));

    //
    // Places
    //
    final distanceGroups = $(cans).group((candidate) {
      num sumOfDistance = 0;
      num sumOfSquaredDistance = 0;
      int count = 0;
      for (final b in ballots) {
        final distance = b.getDistance(candidate);
        sumOfDistance += distance;
        sumOfSquaredDistance += distance * distance;
        count++;
      }

      return new Tuple<num, num>(
          sumOfDistance / count, sumOfSquaredDistance / count);
    });

    final distances = new List<Tuple<num, num>>.from(distanceGroups.getKeys());
    distances.sort((a, b) => a.item1.compareTo(b.item1));

    int placeNumber = 1;
    final places = new List.unmodifiable(distances.map((d) {
      var placeCans = distanceGroups[d];
      final place =
          new DistanceElectionPlace(placeNumber, placeCans, d.item1, d.item2);
      placeNumber += placeCans.length;
      return place;
    }));

    return new DistanceElection._internal(cans, ballots, places);
  }
}
