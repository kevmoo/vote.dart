import 'package:graphs/graphs.dart';
import 'package:meta/meta.dart';

import 'condorcet_pair.dart';
import 'election.dart';
import 'election_place.dart';
import 'ranked_ballot.dart';

@immutable
class CondorcetElection<TCandidate extends Comparable>
    extends Election<TCandidate, ElectionPlace<TCandidate>>
    with CondorcetElectionResult<TCandidate> {
  @override
  final Set<CondorcetPair<TCandidate>> pairs;

  CondorcetElection._internal(
    this.pairs,
    List<TCandidate> candidates,
    List<RankedBallot<TCandidate>> ballots,
    List<ElectionPlace<TCandidate>> places,
  ) : super(
          candidates: candidates,
          ballots: ballots,
          places: places,
        );

  factory CondorcetElection(
    List<RankedBallot<TCandidate>> ballots, {
    Iterable<TCandidate>? candidates,
  }) {
    final ballotCandidates = ballots.expand((b) => b.rank).toSet();

    final candidateSet =
        candidates == null ? ballotCandidates : candidates.toSet();

    assert(
      candidates == null || candidateSet.containsAll(ballotCandidates),
      'If `candidates` is provided, then every candidate in `ballots` should '
      'exist in `candidates`.',
    );

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

abstract class CondorcetElectionResult<TCandidate extends Comparable>
    implements ElectionResult<TCandidate, ElectionPlace<TCandidate>> {
  Set<CondorcetPair<TCandidate>> get pairs;

  factory CondorcetElectionResult.fromPairs(
    Set<CondorcetPair<TCandidate>> pairs,
  ) {
    final candidateList = pairs
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

class _CondorcetElectionResultImpl<TCandidate extends Comparable>
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

List<ElectionPlace<TCandidate>> _calculatePlaces<TCandidate extends Comparable>(
  List<TCandidate> candidateList,
  Set<CondorcetPair<TCandidate>> pairs,
) {
  final candidateMap = <TCandidate, Set<TCandidate>>{};

  for (final candidate in candidateList) {
    final lostTo = <TCandidate>[];
    final beat = <TCandidate>[];
    final tied = <TCandidate>[];

    final lostTiedSet = <TCandidate>{};

    for (final pair in pairs) {
      if (pair.candidate1 == candidate || pair.candidate2 == candidate) {
        final other =
            (pair.candidate1 == candidate) ? pair.candidate2 : pair.candidate1;

        if (pair.isTie) {
          tied.add(other);
          lostTiedSet.add(other);
        } else if (pair.winner == candidate) {
          beat.add(other);
        } else {
          assert(pair.winner == other);
          lostTo.add(other);
          lostTiedSet.add(other);
        }
      }
    }

    candidateMap[candidate] = lostTiedSet;
  }

  final components = stronglyConnectedComponents<TCandidate>(
    candidateMap.keys,
    (node) => candidateMap[node]!,
  )..sort((a, b) {
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
    });

  final places = <ElectionPlace<TCandidate>>[];
  var placeNumber = 1;
  for (final round in components) {
    final place = ElectionPlace<TCandidate>(placeNumber, round..sort());
    places.add(place);
    placeNumber += round.length;
  }

  return places;
}
