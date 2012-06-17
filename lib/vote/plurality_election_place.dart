class PluralityElectionPlace<TCandidate extends Player>
  extends ElectionPlace<TCandidate> {
  final int voteCount;

  PluralityElectionPlace(
    int place, Iterable<TCandidate> candidates, this.voteCount) :
    super(place, candidates) {
      assert(voteCount >= 0);
    }
}
