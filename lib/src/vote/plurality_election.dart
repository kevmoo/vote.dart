import '../grouping.dart';
import '../util.dart';
import 'ballot.dart';
import 'election.dart';
import 'plurality_ballot.dart';
import 'plurality_election_place.dart';

class PluralityElection<TVoter, TCandidate>
    extends Election<TVoter, TCandidate> {
  @override
  final List<Ballot<TVoter>> ballots;
  final Grouping<TCandidate, PluralityBallot> _ballotGroup;

  @override
  final List<PluralityElectionPlace<TCandidate>> places;

  PluralityElection._internal(this.ballots, this._ballotGroup,
      Iterable<PluralityElectionPlace> sourcePlaces)
      : places = List.unmodifiable(sourcePlaces);

  factory PluralityElection(Iterable<PluralityBallot> ballots) {
    final roBallots =
        List<PluralityBallot<TVoter, TCandidate>>.unmodifiable(ballots);

    // Check voter uniqueness
    final voterList = List.unmodifiable(roBallots.map((pb) => pb.voter));
    requireArgument(
        allUnique(voterList), "Only one ballot per voter is allowed");

    final group = Grouping<TCandidate, PluralityBallot<TVoter, TCandidate>>(
        roBallots, (pb) => pb.choice);

    //
    // create a Map of candidates keyed on their vote count
    //
    var voteCounts = Map<int, List<TCandidate>>();
    void f(TCandidate c, List<PluralityBallot> b) {
      var count = b.length;
      List<TCandidate> candidates =
          voteCounts.putIfAbsent(count, () => List<TCandidate>());
      candidates.add(c);
    }

    group.forEach(f);

    //
    // Now the keys of voteCounts are unique, one for each vote count
    //
    var ballotCounts = List<int>.from(voteCounts.keys);

    // NOTE: reverse sorting
    ballotCounts.sort((a, b) => b.compareTo(a));

    int place = 1;
    var places = List<PluralityElectionPlace>();
    for (final int count in ballotCounts) {
      var p = PluralityElectionPlace(place, voteCounts[count], count);
      places.add(p);
      place += p.length;
    }

    return PluralityElection<TVoter, TCandidate>._internal(
        roBallots, group, places);
  }

  @override
  Iterable<TCandidate> get candidates => _ballotGroup.getKeys();
}
