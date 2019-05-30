import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import 'ballot.dart';
import 'election.dart';
import 'plurality_ballot.dart';
import 'plurality_election_place.dart';
import 'util.dart';

@immutable
class PluralityElection<TVoter, TCandidate extends Comparable>
    extends Election<TVoter, TCandidate> {
  @override
  final List<Ballot<TVoter>> ballots;
  final Map<TCandidate, List<PluralityBallot>> _ballotGroup;

  @override
  final List<PluralityElectionPlace<TCandidate>> places;

  PluralityElection._internal(this.ballots, this._ballotGroup, this.places);

  factory PluralityElection(List<PluralityBallot<TVoter, TCandidate>> ballots) {
    // Check voter uniqueness
    final voterList = ballots.map((pb) => pb.voter).toList(growable: false);
    requireArgument(
        allUnique(voterList), 'Only one ballot per voter is allowed');

    final group = groupBy<PluralityBallot<TVoter, TCandidate>, TCandidate>(
        ballots, (pb) => pb.choice);

    //
    // create a Map of candidates keyed on their vote count
    //
    final voteCounts = <int, List<TCandidate>>{};
    void f(TCandidate c, List<PluralityBallot> b) {
      final count = b.length;
      voteCounts.putIfAbsent(count, () => <TCandidate>[]).add(c);
    }

    group.forEach(f);

    //
    // Now the keys of voteCounts are unique, one for each vote count
    //
    final ballotCounts = List<int>.from(voteCounts.keys)
      // NOTE: reverse sorting
      ..sort((a, b) => b.compareTo(a));

    var place = 1;
    final places = <PluralityElectionPlace<TCandidate>>[];
    for (var count in ballotCounts) {
      final p = PluralityElectionPlace(place, voteCounts[count], count);
      places.add(p);
      place += p.length;
    }

    return PluralityElection<TVoter, TCandidate>._internal(
        ballots, group, places);
  }

  @override
  Iterable<TCandidate> get candidates => _ballotGroup.keys;
}
