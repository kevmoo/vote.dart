part of vote;

class IrvElimination<TVoter extends Player, TCandidate extends Player> {
  final TCandidate candidate;
  final Map<TCandidate, List<RankedBallot<TVoter, TCandidate>>> _transfers;
  final ReadOnlyCollection<RankedBallot<TVoter, TCandidate>> exhausted;

  IrvElimination(this.candidate, this._transfers, this.exhausted) {
    assert(candidate != null);
    assert(_transfers != null);
    assert(exhausted != null);
  }

  Iterable<TCandidate> get transferedCandidates => _transfers.keys;

  int getTransferCount(TCandidate key) {
    final list = _transfers[key];
    if(list == null) {
      return 0;
    } else {
      return list.length;
    }
  }
}
