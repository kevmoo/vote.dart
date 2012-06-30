class PluralityElection<TVoter extends Player, TCandidate extends Player>
  implements Election<TVoter, TCandidate> {
  final Grouping<TCandidate, PluralityBallot<TVoter, TCandidate>> _ballots;
  final ReadOnlyCollection<PluralityElectionPlace<TCandidate>> places;

  PluralityElection._internal(
    this._ballots,
    Iterable<PluralityElectionPlace<TCandidate>> sourcePlaces) :
      places = new ReadOnlyCollection(sourcePlaces);

  factory PluralityElection(
    Collection<PluralityBallot<TVoter, TCandidate>> ballots) {

    // Check voter uniqueness
    List<Player> voterList = new List.from(ballots.map((pb) => pb.voter));
    requireArgument(CollectionUtil.allUnique(voterList),
      "Only one ballot per voter is allowed");

    var map = new HashSet<PluralityBallot<TVoter, TCandidate>>();
    map.addAll(ballots);

    Func1<PluralityBallot<TVoter, TCandidate>, TCandidate> getKeyFunc =
        (pb) => pb.choice;

    var group = new Grouping<TCandidate,
        PluralityBallot<TVoter, TCandidate>>(ballots, getKeyFunc);

    //
    // create a hashmap of candidates keyed on their vote count
    //
    var voteCounts = new HashMap<int, List<TCandidate>>();
    Action2<TCandidate, List<PluralityBallot<TVoter, TCandidate>>> f = (c, b) {
      var count = b.length;
      List<TCandidate> candidates =
          voteCounts.putIfAbsent(count, () => new List<TCandidate>());
      candidates.add(c);
    };
    group.forEach(f);

    //
    // Now the keys of voteCounts are unique, one for each vote count
    //
    var ballotCounts = new List<int>.from(voteCounts.getKeys());

    // NOTE: reverse sorting
    ballotCounts.sort((a,b) => b.compareTo(a));

    int place = 1;
    var places = new List<PluralityElectionPlace<TCandidate>>();
    for (final int count in ballotCounts) {
      var p = new PluralityElectionPlace(place, voteCounts[count], count);
      places.add(p);
      place += p.length;
    }

    return new PluralityElection._internal(group, places);
  }

  Collection<TCandidate> get candidates() => _ballots.getKeys();

  Collection<Ballot<TVoter, TCandidate>> get ballots() => _ballots.getValues();

  TCandidate get singleWinner() {
    if(places.length > 0 && places[0].length == 1) {
      return places[0][0];
    }
    else {
      return null;
    }
  }
}
