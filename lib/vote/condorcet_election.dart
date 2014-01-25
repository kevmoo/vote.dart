part of vote;

class CondorcetElection<TVoter extends Player, TCandidate extends Player>
  extends Election<TVoter, TCandidate> {

  final Set<CondorcetPair<TVoter, TCandidate>> _pairs;
  final Map<TCandidate, CondorcetCandidateProfile<TCandidate>> _profiles;
  final ReadOnlyCollection<RankedBallot<TVoter, TCandidate>> ballots;
  final ReadOnlyCollection<ElectionPlace<TCandidate>> places;

  CondorcetElection._internal(this._pairs, this._profiles, this.ballots,
    this.places);

  factory CondorcetElection(
    Iterable<RankedBallot<TVoter, TCandidate>> ballots) {

    final roBallots = new ReadOnlyCollection(ballots);

    // Check voter uniqueness
    final voterList = new ReadOnlyCollection(roBallots.map((b) => b.voter));
    requireArgument(CollectionUtil.allUnique(voterList),
      "Only one ballot per voter is allowed");

    var map = new Map<CondorcetPair<TVoter, TCandidate>, List<RankedBallot<TVoter, TCandidate>>>();
    var candidateSet = new Set<TCandidate>();

    for(final ballot in ballots) {
      for (var i = 0; i < ballot.rank.length; i++) {
        final candidateI = ballot.rank[i];
        candidateSet.add(candidateI);

        for (var j = i + 1; j < ballot.rank.length; j++) {
          final pair = new CondorcetPair(candidateI, ballot.rank[j]);

          final pairBallotList = map.putIfAbsent(pair, () => new List<RankedBallot<TVoter, TCandidate>>());
          pairBallotList.add(ballot);
        }
      }
    }

    var set = new Set<CondorcetPair<TVoter, TCandidate>>();
    map.forEach((k,v) {
      var c = new CondorcetPair(k.item1, k.item2, v);
      set.add(c);
    });

    var candidateProfiles = new Map<TCandidate, CondorcetCandidateProfile<TCandidate>>();
    var tarjanMap = new Map<TCandidate, Set<TCandidate>>();

    for(final candidate in candidateSet) {
      var lostTo = new List<TCandidate>();
      var beat = new List<TCandidate>();
      var tied = new List<TCandidate>();

      final tarjanLostTiedSet = new Set<TCandidate>();

      for(final pair in set) {
        if(pair.item1 == candidate || pair.item2 == candidate) {
          final other = (pair.item1 == candidate) ? pair.item2 : pair.item1;

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

    var components = stronglyConnectedComponents(tarjanMap);

    var places = new List<ElectionPlace<TCandidate>>();
    int placeNumber = 1;
    for(final round in components) {
      final place = new ElectionPlace(placeNumber, round);
      places.add(place);
      placeNumber += round.length;
    }

    return new CondorcetElection._internal(
      set, candidateProfiles, roBallots,
      new ReadOnlyCollection<ElectionPlace<TCandidate>>(places));
  }

  Iterable<TCandidate> get candidates => _profiles.keys;

  CondorcetPair<TVoter, TCandidate> getPair(TCandidate c1, TCandidate c2) {
    var filter = _pairs.where((p) => p.matches(c1, c2));
    assert(filter.length <= 1);
    if(filter.isEmpty) {
      return null;
    } else {
      assert(filter.length == 1);
      return filter.first.flip(c1, c2);
    }
  }
}
