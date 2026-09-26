import 'package:graphs/graphs.dart';
import 'package:meta/meta.dart';

import 'condorcet_pair.dart';
import 'election.dart';
import 'election_place.dart';
import 'ranked_ballot.dart';
import 'util.dart';

@immutable
class CondorcetElection<TCandidate extends Comparable<dynamic>>
    extends Election<TCandidate, ElectionPlace<TCandidate>>
    with CondorcetElectionResult<TCandidate> {
  @override
  final Set<CondorcetPair<TCandidate>> pairs;

  CondorcetElection._internal(
    this.pairs,
    List<TCandidate> candidates,
    List<RankedBallot<TCandidate>> ballots,
    List<ElectionPlace<TCandidate>> places,
  ) : super(candidates: candidates, ballots: ballots, places: places);

  factory CondorcetElection(
    List<RankedBallot<TCandidate>> ballots, {
    Iterable<TCandidate>? candidates,
  }) {
    final candidateSet = validateRankedBallotCandidates(ballots, candidates);

    final candidateList = candidateSet.toList(growable: false)..sort();

    Iterable<CondorcetPair<TCandidate>> iteratePairs() sync* {
      for (var i = 0; i < candidateList.length; i++) {
        for (var j = i + 1; j < candidateList.length; j++) {
          yield CondorcetPair(candidateList[i], candidateList[j], ballots);
        }
      }
    }

    final pairs = Set.unmodifiable(iteratePairs());

    final places = _calculatePlaces(candidateList, pairs);

    return CondorcetElection._internal(
      pairs,
      places.expand((p) => p).toList(growable: false),
      ballots,
      places,
    );
  }
}

abstract mixin class CondorcetElectionResult<
  TCandidate extends Comparable<dynamic>
>
    implements ElectionResult<TCandidate, ElectionPlace<TCandidate>> {
  Set<CondorcetPair<TCandidate>> get pairs;

  factory CondorcetElectionResult.fromPairs(
    Set<CondorcetPair<TCandidate>> pairs,
  ) {
    final candidateList =
        pairs
            .expand((element) => [element.candidate1, element.candidate2])
            .toSet()
            .toList();

    final places = _calculatePlaces(candidateList, pairs);

    final flattenedPlaces = places.expand((element) => element).toList();

    candidateList.sort(
      (a, b) =>
          flattenedPlaces.indexOf(a).compareTo(flattenedPlaces.indexOf(b)),
    );

    return _CondorcetElectionResultImpl._(pairs, candidateList, places);
  }

  CondorcetPair<TCandidate> getPair(TCandidate c1, TCandidate c2) {
    assert(candidates.contains(c1));
    assert(candidates.contains(c2));

    return pairs.singleWhere((p) => p.matches(c1, c2)).flip(c1);
  }
}

class _CondorcetElectionResultImpl<TCandidate extends Comparable<dynamic>>
    extends ElectionResult<TCandidate, ElectionPlace<TCandidate>>
    with CondorcetElectionResult<TCandidate> {
  @override
  final Set<CondorcetPair<TCandidate>> pairs;

  _CondorcetElectionResultImpl._(
    this.pairs,
    List<TCandidate> candidates,
    List<ElectionPlace<TCandidate>> places,
  ) : super(candidates: candidates, places: places);
}

/// Calculates the [ElectionPlace] rankings for a Condorcet election by
/// resolving strongly connected components across pairwise head-to-head
/// results.
List<ElectionPlace<TCandidate>> _calculatePlaces<
  TCandidate extends Comparable<dynamic>
>(List<TCandidate> candidateList, Set<CondorcetPair<TCandidate>> pairs) {
  final candidateMap = <TCandidate, Set<TCandidate>>{
    for (final candidate in candidateList)
      candidate: _getLostOrTied(candidate, pairs),
  };

  final components = stronglyConnectedComponents<TCandidate>(
    candidateMap.keys,
    (node) => candidateMap[node]!,
  )..sort((a, b) => _compareComponents(a, b, pairs));

  final places = <ElectionPlace<TCandidate>>[];
  var placeNumber = 1;
  for (final round in components) {
    final place = ElectionPlace<TCandidate>(placeNumber, round..sort());
    places.add(place);
    placeNumber += round.length;
  }

  return places;
}

/// Collects all opponent candidates that [candidate] either lost to or tied
/// against in the provided head-to-head [pairs].
Set<TCandidate> _getLostOrTied<TCandidate extends Comparable<dynamic>>(
  TCandidate candidate,
  Set<CondorcetPair<TCandidate>> pairs,
) => {
  for (final pair in pairs)
    if (pair.candidate1 == candidate || pair.candidate2 == candidate)
      if (pair.isTie || pair.winner != candidate)
        (pair.candidate1 == candidate) ? pair.candidate2 : pair.candidate1,
};

/// Compares two strongly connected components [a] and [b] using the
/// head-to-head pair outcome between their representative candidates.
int _compareComponents<TCandidate extends Comparable<dynamic>>(
  List<TCandidate> a,
  List<TCandidate> b,
  Set<CondorcetPair<TCandidate>> pairs,
) {
  final firstA = a.first;
  final firstB = b.first;

  final pair = pairs.singleWhere((p) => p.matches(firstA, firstB));

  if (pair.isTie) {
    return 0;
  }

  if (pair.winner == firstA) {
    return -1;
  }

  assert(pair.winner == firstB);
  return 1;
}
