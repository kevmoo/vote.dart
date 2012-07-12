class CondorcetElection<TVoter extends Player, TCandidate extends Player>
  implements Election<TVoter, TCandidate> {

  final HashSet<CondorcetPair<TVoter, TCandidate>> _pairs;
  final HashMap<TCandidate, CondorcetCandidateProfile<TCandidate>> _profiles;
  final ReadOnlyCollection<RankedBallot<TVoter, TCandidate>> ballots;
  final ReadOnlyCollection<ElectionPlace<TCandidate>> places;

  CondorcetElection._internal(this._pairs, this._profiles, this.ballots,
    this.places);

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
    var tarjanMap = new HashMap<TCandidate, HashSet<TCandidate>>();

    for(final candidate in candidateHashSet) {
      var lostTo = new List<TCandidate>();
      var beat = new List<TCandidate>();
      var tied = new List<TCandidate>();

      final tarjanLostTiedSet = new HashSet<TCandidate>();

      for(final pair in hashSet) {
        if(pair.Item1 == candidate || pair.Item2 == candidate) {
          final other = (pair.Item1 == candidate) ? pair.Item2 : pair.Item1;

          if(pair.isTie) {
            tied.add(other);
            tarjanLostTiedSet.add(other);
          }
          else if(pair.winner == candidate) {
            beat.add(other);
          }
          else {
            assert(pair.winner == other);
            lostTo.add(other);
            tarjanLostTiedSet.add(other);
          }
        }
      }

      var profile = new CondorcetCandidateProfile._internal(candidate,
        new ReadOnlyCollection(lostTo),
        new ReadOnlyCollection(beat),
        new ReadOnlyCollection(tied));
      candidateProfiles[candidate] = profile;

      tarjanMap[candidate] = tarjanLostTiedSet;
    }

    var components = TarjanCycleDetect.getStronglyConnectedComponents(tarjanMap);

    var places = new List<ElectionPlace<TCandidate>>();
    int placeNumber = 1;
    for(final round in components) {
      final place = new ElectionPlace(placeNumber, round);
      places.add(place);
      placeNumber += round.length;
    }

    return new CondorcetElection._internal(
      hashSet, candidateProfiles, bals,
      new ReadOnlyCollection<ElectionPlace<TCandidate>>(places));
  }

  Collection<TCandidate> get candidates() => _profiles.getKeys();

  TCandidate get singleWinner() {
    if(places.length > 0 && places[0].length == 1) {
      return places[0][0];
    }
    else {
      return null;
    }
  }

  CondorcetPair<TVoter, TCandidate> getPair(TCandidate c1, TCandidate c2) {
    var filter = _pairs.filter((p) => p.matches(c1, c2));
    assert(filter.length <= 1);
    if(filter.isEmpty()) {
      return null;
    } else {
      assert(filter.length == 1);
      return filter.iterator().next().flip(c1, c2);
    }
  }
}
