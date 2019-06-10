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
    assert(allUnique(voterList), 'Only one ballot per voter is allowed');

    final group = groupBy<PluralityBallot<TVoter, TCandidate>, TCandidate>(
        ballots, (pb) => pb.choice);

    //
    // create a Map of candidates keyed on their vote count
    //
    final voteCounts = <int, List<TCandidate>>{};

    for (var entry in group.entries) {
      voteCounts
          .putIfAbsent(entry.value.length, () => <TCandidate>[])
          .add(entry.key);
    }

    //
    // Now the keys of voteCounts are unique, one for each vote count
    //
    final ballotCounts = voteCounts.keys.toList(growable: false)
      // NOTE: reverse sorting
      ..sort((a, b) => b.compareTo(a));

    var place = 1;
    final places = <PluralityElectionPlace<TCandidate>>[];
    for (var count in ballotCounts) {
      final p = PluralityElectionPlace(place, voteCounts[count]..sort(), count);
      places.add(p);
      place += p.length;
    }

    return PluralityElection<TVoter, TCandidate>._internal(
        ballots, group, places);
  }

  @override
  Iterable<TCandidate> get candidates => _ballotGroup.keys;
}
