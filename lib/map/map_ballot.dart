class MapBallot<TVoter extends MapPlayer, TCandidate extends MapPlayer>
  extends RankedBallot<TVoter, TCandidate> {
  final HashMap<TCandidate, num> _distances;

  MapBallot._internal(TVoter voter, ReadOnlyCollection<TCandidate> items,
    this._distances):
    super.protected(voter, items);

  factory MapBallot(TVoter voter, Iterable<TCandidate> candidates) {
    final distances = $(candidates).toHashMap((c) {
      return voter.location.getDistance(c.location).toInt();
    });

    var rank = new List<MapPlayer>.from(candidates);
    requireArgument(rank.length > 0, 'candidates');
    requireArgument(CollectionUtil.allUnique(rank), 'candidates');
    rank.sort((a,b) => distances[a].compareTo(distances[b]));

    var items = new ReadOnlyCollection(rank);

    return new MapBallot._internal(voter, items, distances);
  }

  num getDistance(TCandidate candidate) {
    return _distances[candidate];
  }
}
