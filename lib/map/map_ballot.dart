class MapBallot<TVoter extends MapPlayer, TCandidate extends MapPlayer>
  extends RankedBallot<TVoter, TCandidate> {
  final HashMap<TCandidate, num> _distances;

  MapBallot._internal(TVoter voter, ReadOnlyCollection<TCandidate> items,
    this._distances):
    super.protected(voter, items);

  // TODO: distances is mutable -- scary
  factory MapBallot(TVoter voter, Iterable<TCandidate> rank,
    HashMap<TCandidate, num> distances) {
    requireArgumentNotNull(voter, 'voter');
    requireArgumentNotNull(rank, 'rank');
    requireArgumentNotNull(distances, 'distances');

    var items = new ReadOnlyCollection(rank);
    requireArgument(items.length > 0, 'rank');
    requireArgument(CollectionUtil.allUnique(items), 'rank');

    assert(distances.length == items.length);
    items.forEach((c) {
      assert(distances.containsKey(c));
    });

    return new MapBallot._internal(voter, items, distances);
  }

  num getDistance(TCandidate candidate) {
    return _distances[candidate];
  }
}
