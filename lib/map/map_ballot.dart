class MapBallot<TVoter extends MapPlayer, TCandidate extends MapPlayer>
  extends RankedBallot<TVoter, TCandidate> {
  final HashMap<TCandidate, num> _distances;

  MapBallot._internal(TVoter voter, ReadOnlyCollection<TCandidate> items,
    this._distances):
    super.protected(voter, items);

  factory MapBallot(TVoter voter, Iterable<TCandidate> candidates) {
    final distances = $(candidates).toHashMap((c) {
      var d = voter.location.getDistance(c.location);
      return (d * 128).toInt() / 128;
    });

    var rank = new List<MapPlayer>.from(candidates);
    requireArgument(rank.length > 0, 'candidates');
    requireArgument(CollectionUtil.allUnique(rank), 'candidates');
    rank.sort((a,b) {
      var d = distances[a].compareTo(distances[b]);
      if(d == 0) {
        // ensure ranking of tied candidates is random-ish
        d = (Math.random() < 0.5) ? -1 : 1;
      }
      return d;
    });

    var items = new ReadOnlyCollection(rank);

    return new MapBallot._internal(voter, items, distances);
  }

  num getDistance(TCandidate candidate) {
    return _distances[candidate];
  }
}
