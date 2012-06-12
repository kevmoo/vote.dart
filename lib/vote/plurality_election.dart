class PluralityElection<TVoter extends Hashable, TCandidate extends Hashable>
  implements Election<TVoter, TCandidate>{
  final HashSet<PluralityBallot<TVoter, TCandidate>> _ballots;

  PluralityElection._internal(this._ballots);

  factory PluralityElection(
    Collection<PluralityBallot<TVoter, TCandidate>> ballots) {
    var map = new HashSet<PluralityBallot<TVoter, TCandidate>>();
    map.addAll(ballots);
    return new PluralityElection._internal(map);
  }

  Iterable<TVoter> get voters() {
    return _ballots.map((pb) => pb.voter);
  }

  Iterable<Ballot<TVoter, TCandidate>> get ballots() {
    return _ballots;
  }
}
