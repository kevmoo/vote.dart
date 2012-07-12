class MapElection <TVoter extends MapPlayer, TCandidate extends MapPlayer>
  implements Election<TVoter, TCandidate> {

  final ReadOnlyCollection<TCandidate> candidates;
  final ReadOnlyCollection<MapBallot<TVoter, TCandidate>> ballots;
  final ReadOnlyCollection<MapElectionPlace<TCandidate>> places;

  MapElection._internal(this.candidates, this.ballots, this.places);

  factory MapElection(Iterable<TVoter> voters, Iterable<TCandidate> candidates) {
    final cans = new ReadOnlyCollection<TCandidate>(candidates);

    final ballots = $(voters)
        .select((voter) {
          final distances = $(candidates).toHashMap((c) {
            return voter.location.getDistance(c.location).toInt();
          });

          var canList = new List<MapPlayer>.from(cans);
          canList.sort((a,b) => distances[a].compareTo(distances[b]));

          return new MapBallot<MapPlayer, MapPlayer>(voter, canList, distances);
        })
        .toReadOnlyCollection();

    //
    // Places
    //
    final distanceGroups = $(cans).group((candidate) {
      num sumOfDistance = 0;
      num sumOfSquaredDistance = 0;
      int count = 0;
      for(final b in ballots) {
        final distance = b.getDistance(candidate);
        sumOfDistance += distance;
        sumOfSquaredDistance += distance * distance;
        count++;
      }

      return new Tuple<num, num>(sumOfDistance / count, sumOfSquaredDistance / count);
    });

    final distances = new List<Tuple<num,num>>.from(distanceGroups.getKeys());
    distances.sort((a,b) => a.Item1.compareTo(b.Item1));

    int placeNumber = 1;
    final places = $(distances).select((d) {
      var placeCans = distanceGroups[d];
      final place = new MapElectionPlace(placeNumber, placeCans,
        d.Item1, d.Item2);
      placeNumber += placeCans.length;
      return place;
    }).toReadOnlyCollection();

    return new MapElection._internal(cans, ballots, places);
  }

  TCandidate get singleWinner() {
    throw 'not implemented';
  }
}
