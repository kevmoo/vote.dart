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
    Iterable<TCandidate>? candidates,
  }) {
    var candidateVotes = <TCandidate, int>{};

    for (var ballot in ballots) {
      candidateVotes[ballot.choice] = (candidateVotes[ballot.choice] ?? 0) + 1;
    }

    if (candidates != null) {
      assert(
        candidateVotes.keys.every(candidates.contains),
        'If `candidates` is provided, then every candidate in `ballots` should '
        'exist in `candidates`.',
      );
      for (var candidate in candidates) {
        candidateVotes.putIfAbsent(candidate, () => 0);
      }
    }

    candidateVotes = {
      for (var entry
          in candidateVotes.entries.toList()
            ..sort((a, b) => a.key.compareTo(b.key)))
        entry.key: entry.value,
    };

    final groups = groupBy(candidateVotes.keys, (c) => candidateVotes[c]!)
        .entries
        .toList(growable: false)
      // NOTE: reverse sorting
      ..sort((a, b) => b.key.compareTo(a.key));

    var place = 1;
    final places = <PluralityElectionPlace<TCandidate>>[];
    for (var count in groups) {
      final p = PluralityElectionPlace(place, count.value, count.key);
      places.add(p);
      place += p.length;
    }

    return PluralityElection._internal(
      ballots,
      candidateVotes.keys.toList(growable: false),
      places,
    );
  }
}
