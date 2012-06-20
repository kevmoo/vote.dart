class RankedBallot<TVoter extends Player, TCandidate extends Player>
  extends PluralityBallot<TVoter, TCandidate> {
  final ReadOnlyCollection<TCandidate> rank;

  RankedBallot._internal(TVoter voter, ReadOnlyCollection<TCandidate> items):
    super(voter, items[0]),
    rank = items;

  factory RankedBallot(TVoter voter, Iterable<TCandidate> rank) {
    if(voter == null) {
      throw const IllegalArgumentException('voter');
    }

    if(rank == null) {
      throw const IllegalArgumentException('rank');
    }
    var items = new ReadOnlyCollection(rank);
    if(items.length == 0) {
      throw const IllegalArgumentException('rank');
    }
    if(!CollectionUtil.allUnique(items)) {
      throw const IllegalArgumentException('rank');
    }

    return new RankedBallot._internal(voter, items);
  }
}
