class PluralityElection<TVoter extends Player, TCandidate extends Player>
  implements Election<TVoter, TCandidate> {
  final HashSet<PluralityBallot<TVoter, TCandidate>> _ballots;

  PluralityElection._internal(this._ballots);

  factory PluralityElection(
    Collection<PluralityBallot<TVoter, TCandidate>> ballots) {

    // Check voter uniqueness
    List<Player> voterList = new List.from(ballots.map((pb) => pb.voter));
    if(!CollectionUtil.allUnique(voterList)) {
      throw "Only one ballot per voter is allowed";
    }

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
