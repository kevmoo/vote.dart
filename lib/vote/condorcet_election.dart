class CondorcetElection<TVoter extends Player, TCandidate extends Player>
  implements Election<TVoter, TCandidate> {

  factory CondorcetElection(
    Collection<RankedBallot<TVoter, TCandidate>> ballots) {

    // Check voter uniqueness
    List<Player> voterList = new List.from(ballots.map((pb) => pb.voter));
    requireArgument(CollectionUtil.allUnique(voterList),
      "Only one ballot per voter is allowed");

    var hashMap = new HashMap<CondorcetPair<TCandidate>, List<RankedBallot<TVoter, TCandidate>>>();

    for(final ballot in ballots) {
      for (var i = 0; i < ballot.rank.length; i++) {
        for (var j = i + 1; j < ballot.rank.length; j++) {
          final pair = new CondorcetPair(ballot.rank[i], ballot.rank[j]);

          final pairBallotList = hashMap.putIfAbsent(pair, () => new List<RankedBallot<TVoter, TCandidate>>());
          pairBallotList.add(ballot);
        }
      }
    }
  }

  Iterable<TCandidate> get candidates() {
    throw const NotImplementedException();
  }

  Iterable<RankedBallot<TVoter, TCandidate>> get ballots() {
    throw const NotImplementedException();
  }

  TCandidate get singleWinner() {
    throw const NotImplementedException();
  }

  ReadOnlyCollection<ElectionPlace<TCandidate>> get places() {
    throw const NotImplementedException();
  }
}
