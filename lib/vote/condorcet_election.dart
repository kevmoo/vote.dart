class CondorcetElection<TVoter extends Player, TCandidate extends Player>
  implements Election<TVoter, TCandidate> {

  final HashSet<CondorcetPair<TVoter, TCandidate>> _pairs;
  final HashMap<TCandidate, CondorcetCandidateProfile<TCandidate>> _profiles;
  final ReadOnlyCollection<RankedBallot<TVoter, TCandidate>> ballots;
  final TCandidate singleWinner;

  CondorcetElection._internal(this._pairs, this._profiles, this.ballots,
    this.singleWinner);

  factory CondorcetElection(
    Collection<RankedBallot<TVoter, TCandidate>> ballots) {

    var bals = new ReadOnlyCollection<RankedBallot<TVoter, TCandidate>>(ballots);

    // Check voter uniqueness
    List<Player> voterList = new List.from(ballots.map((pb) => pb.voter));
    requireArgument(CollectionUtil.allUnique(voterList),
      "Only one ballot per voter is allowed");

    var hashMap = new HashMap<CondorcetPair<TVoter, TCandidate>, List<RankedBallot<TVoter, TCandidate>>>();
    var candidateHashSet = new HashSet<TCandidate>();

    for(final ballot in ballots) {
      for (var i = 0; i < ballot.rank.length; i++) {
        final candidateI = ballot.rank[i];
        candidateHashSet.add(candidateI);

        for (var j = i + 1; j < ballot.rank.length; j++) {
          final pair = new CondorcetPair(candidateI, ballot.rank[j]);

          final pairBallotList = hashMap.putIfAbsent(pair, () => new List<RankedBallot<TVoter, TCandidate>>());
          pairBallotList.add(ballot);
        }
      }
    }

    var hashSet = new HashSet<CondorcetPair<TVoter, TCandidate>>();
    hashMap.forEach((k,v) {
      var c = new CondorcetPair(k.Item1, k.Item2, v);
      hashSet.add(c);
    });

    var candidateProfiles = new HashMap<TCandidate, CondorcetCandidateProfile<TCandidate>>();
    TCandidate singleWinner = null;

    //
    // And now we find the smith set :-)
    //
    for(final candidate in candidateHashSet) {
      var lostTo = new List<TCandidate>();
      var beat = new List<TCandidate>();
      var tied = new List<TCandidate>();

      for(final pair in hashSet) {
        if(pair.Item1 == candidate || pair.Item2 == candidate) {
          final other = (pair.Item1 == candidate) ? pair.Item2 : pair.Item1;

          if(pair.isTie) {
            tied.add(other);
          }
          else if(pair.winner == candidate) {
            beat.add(other);
          }
          else {
            assert(pair.winner == other);
            lostTo.add(other);
          }
        }
      }

      var profile = new CondorcetCandidateProfile._internal(candidate,
        new ReadOnlyCollection(lostTo),
        new ReadOnlyCollection(beat),
        new ReadOnlyCollection(tied));
      candidateProfiles[candidate] = profile;

      if(profile.tied.length == 0 && profile.lostTo.length == 0) {
        assert(singleWinner == null);
        singleWinner = candidate;
      }
    }

    return new CondorcetElection._internal(hashSet, candidateProfiles, bals,
      singleWinner);
  }

  Collection<TCandidate> get candidates() => _profiles.getKeys();

  ReadOnlyCollection<ElectionPlace<TCandidate>> get places() {
    throw const NotImplementedException();
  }
}
