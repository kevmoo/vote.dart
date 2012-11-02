part of vote;

class PluralityElection<TVoter extends Player, TCandidate extends Player>
  extends Election<TVoter, TCandidate> {
  final ReadOnlyCollection<Ballot<TVoter, TCandidate>> ballots;
  final Grouping<TCandidate, PluralityBallot<TVoter, TCandidate>> _ballotGroup;
  final ReadOnlyCollection<PluralityElectionPlace<TCandidate>> places;

  PluralityElection._internal(this.ballots, this._ballotGroup,
    Iterable<PluralityElectionPlace<TCandidate>> sourcePlaces) :
      places = new ReadOnlyCollection(sourcePlaces);

  factory PluralityElection(
    Collection<PluralityBallot<TVoter, TCandidate>> ballots) {

    final roBallots = $(ballots).toReadOnlyCollection();

    // Check voter uniqueness
    final voterList = roBallots.map((pb) => pb.voter).toReadOnlyCollection();
    requireArgument(CollectionUtil.allUnique(voterList),
      "Only one ballot per voter is allowed");

    final group = roBallots.group((pb) => pb.choice);

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
    var ballotCounts = new List<int>.from(voteCounts.keys);

    // NOTE: reverse sorting
    ballotCounts.sort((a,b) => b.compareTo(a));

    int place = 1;
    var places = new List<PluralityElectionPlace<TCandidate>>();
    for (final int count in ballotCounts) {
      var p = new PluralityElectionPlace(place, voteCounts[count], count);
      places.add(p);
      place += p.length;
    }

    return new PluralityElection._internal(roBallots, group, places);
  }

  Collection<TCandidate> get candidates => _ballotGroup.getKeys();
}
