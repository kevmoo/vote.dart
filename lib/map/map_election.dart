class MapElection {
  static List<RankedBallot<MapPlayer, MapPlayer>> createBallots(
    Iterable<MapPlayer> voters, Iterable<MapPlayer> candidates) {

    var ballots = new List<RankedBallot<MapPlayer, MapPlayer>>();
    for (final voter in voters) {
      var distances = new HashMap<MapPlayer, num>();

      for (final candidate in candidates) {
        distances[candidate] = voter.location.getDistance(candidate.location);
      }

      var canList = new List<MapPlayer>.from(candidates);
      canList.sort((a,b) => distances[a].compareTo(distances[b]));

      ballots.add(new RankedBallot<MapPlayer, MapPlayer>(voter, canList));
    }

    return ballots;
  }
}
