part of vote.map;

class DistanceElection<TVoter extends MapPlayer, TCandidate extends MapPlayer>
  extends Election<TVoter, TCandidate> {

  final ReadOnlyCollection<TCandidate> candidates;
  final ReadOnlyCollection<DistanceBallot<TVoter, TCandidate>> ballots;
  final ReadOnlyCollection<DistanceElectionPlace<TCandidate>> places;

  DistanceElection._internal(this.candidates, this.ballots, this.places);

  factory DistanceElection.fromData(LocationData data) {
    return new DistanceElection(data.voters, data.candidates);
  }

  factory DistanceElection(Iterable<TVoter> voters, Iterable<TCandidate> candidates) {
    final cans = new ReadOnlyCollection<TCandidate>(candidates);

    final ballots = new ReadOnlyCollection(voters
        .map((voter) => new DistanceBallot<MapPlayer, MapPlayer>(voter, cans)));

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
    distances.sort((a,b) => a.item1.compareTo(b.item1));

    int placeNumber = 1;
    final places = new ReadOnlyCollection(distances.map((d) {
      var placeCans = distanceGroups[d];
      final place = new DistanceElectionPlace(placeNumber, placeCans,
        d.item1, d.item2);
      placeNumber += placeCans.length;
      return place;
    }));

    return new DistanceElection._internal(cans, ballots, places);
  }
}
