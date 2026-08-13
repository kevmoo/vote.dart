import 'package:collection/collection.dart';

import 'plurality_election_place.dart';
import 'ranked_ballot.dart';

int majorityThreshold(int votes) {
  assert(votes > 0);
  return votes ~/ 2 + 1;
}

bool sorted(Iterable<Comparable> items) {
  Comparable? last;
  for (var item in items) {
    if (last != null && last.compareTo(item) > 0) {
      return false;
    }
    last = item;
  }

  return true;
}

/// Calculates the sorted list of candidates and corresponding
/// [PluralityElectionPlace]s based on the raw [candidateVotes] map and an
/// optional [candidates] roster.
///
/// Ensures all nominated [candidates] are represented (padding zero-vote
/// tallies) and groups tied vote counts in descending order.
({List<TCandidate> candidates, List<PluralityElectionPlace<TCandidate>> places})
calculatePluralityPlaces<TCandidate extends Comparable>(
  Map<TCandidate, int> candidateVotes,
  Iterable<TCandidate>? candidates,
) {
  if (candidates != null) {
    assert(
      candidateVotes.keys.every(candidates.contains),
      'If `candidates` is provided, then every candidate in `ballots` should '
      'exist in `candidates`.',
    );
    for (final candidate in candidates) {
      candidateVotes.putIfAbsent(candidate, () => 0);
    }
  }

  final sortedVotes = {
    for (final entry
        in candidateVotes.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key)))
      entry.key: entry.value,
  };

  final groups = groupBy(
      sortedVotes.keys,
      (c) => sortedVotes[c]!,
    ).entries.toList(growable: false)
    // NOTE: reverse sorting
    ..sort((a, b) => b.key.compareTo(a.key));

  var place = 1;
  final places = <PluralityElectionPlace<TCandidate>>[];
  for (final count in groups) {
    final p = PluralityElectionPlace(place, count.value, count.key);
    places.add(p);
    place += p.length;
  }

  return (candidates: sortedVotes.keys.toList(growable: false), places: places);
}

/// Extracts all candidate identifiers referenced across [ballots] and validates
/// that they are a subset of the explicit [candidates] roster if provided.
Set<TCandidate> validateRankedBallotCandidates<TCandidate extends Comparable>(
  List<RankedBallot<TCandidate>> ballots,
  Iterable<TCandidate>? candidates,
) {
  final ballotCandidates = ballots.expand((b) => b.rank).toSet();
  final candidateSet =
      candidates == null ? ballotCandidates : candidates.toSet();

  assert(
    candidates == null || candidateSet.containsAll(ballotCandidates),
    'If `candidates` is provided, then every candidate in `ballots` should '
    'exist in `candidates`.',
  );

  return candidateSet;
}

extension ListExt<T> on List<T> {
  bool get allUnique {
    final seen = <T>{};
    for (var item in this) {
      assert(item != null);
      if (!seen.add(item)) return false;
    }
    return true;
  }
}
