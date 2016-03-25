import 'package:bot/bot.dart' hide ReadOnlyCollection;

import 'ballot.dart';
import 'election.dart';
import 'plurality_ballot.dart';
import 'plurality_election_place.dart';

class PluralityElection<TVoter, TCandidate extends Comparable>
    extends Election<TVoter, TCandidate> {
  @override
  final List<Ballot<TVoter>> ballots;
  final Grouping<TCandidate, PluralityBallot> _ballotGroup;

  @override
  final List<PluralityElectionPlace<TCandidate>> places;

  PluralityElection._internal(this.ballots, this._ballotGroup,
      Iterable<PluralityElectionPlace> sourcePlaces)
      : places = new List.unmodifiable(sourcePlaces);

  factory PluralityElection(Iterable<PluralityBallot> ballots) {
    final roBallots = new List.unmodifiable(ballots);

    // Check voter uniqueness
    final voterList = new List.unmodifiable(roBallots.map((pb) => pb.voter));
    requireArgument(CollectionUtil.allUnique(voterList),
        "Only one ballot per voter is allowed");

    final group = $(roBallots).group((pb) => pb.choice);

    //
    // create a Map of candidates keyed on their vote count
    //
    var voteCounts = new Map<int, List<TCandidate>>();
    Action2<TCandidate, List<PluralityBallot>> f = (c, b) {
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
    ballotCounts.sort((a, b) => b.compareTo(a));

    int place = 1;
    var places = new List<PluralityElectionPlace>();
    for (final int count in ballotCounts) {
      var p = new PluralityElectionPlace(place, voteCounts[count], count);
      places.add(p);
      place += p.length;
    }

    return new PluralityElection._internal(roBallots, group, places);
  }

  @override
  Iterable<TCandidate> get candidates => _ballotGroup.getKeys();
}
