import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import 'ballot.dart';
import 'election.dart';
import 'plurality_ballot.dart';
import 'plurality_election_place.dart';

@immutable
class PluralityElection<TCandidate extends Comparable>
    extends Election<TCandidate, PluralityElectionPlace<TCandidate>> {
  PluralityElection._internal(
    List<Ballot<TCandidate>> ballots,
    List<TCandidate> candidates,
    List<PluralityElectionPlace<TCandidate>> places,
  ) : super(
          candidates: candidates,
          ballots: ballots,
          places: places,
        );

  factory PluralityElection(
    List<PluralityBallot<TCandidate>> ballots, {
    Iterable<TCandidate> candidates,
  }) {
    final group = groupBy<PluralityBallot<TCandidate>, TCandidate>(
        ballots, (pb) => pb.choice);

    final noVoteCandidates = <TCandidate>{};
    if (candidates != null) {
      assert(
        group.keys.every(candidates.contains),
        'If `candidates` is provided, then every candidate in `ballots` should '
        'exist in `candidates`.',
      );

      noVoteCandidates
        ..addAll(candidates)
        ..removeAll(group.keys);

      for (var noVoteCandidate in noVoteCandidates) {
        group[noVoteCandidate] = [];
      }
    }

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

    return PluralityElection<TCandidate>._internal(
      ballots,
      group.keys.toList(growable: false),
      places,
    );
  }
}
