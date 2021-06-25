import 'package:graphs/graphs.dart';
import 'package:meta/meta.dart';

import 'condorcet_pair.dart';
import 'election.dart';
import 'election_place.dart';
import 'ranked_ballot.dart';

@immutable
class CondorcetElection<TCandidate extends Comparable>
    extends Election<TCandidate, ElectionPlace<TCandidate>>
    implements CondorcetElectionResult<TCandidate> {
  final Set<CondorcetPair<TCandidate>> _pairs;

  CondorcetElection._internal(
    this._pairs,
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

    final candidateMap = <TCandidate, Set<TCandidate>>{};

    for (final candidate in candidateList) {
      final lostTo = <TCandidate>[];
      final beat = <TCandidate>[];
      final tied = <TCandidate>[];

      final lostTiedSet = <TCandidate>{};

      for (final pair in pairs) {
        if (pair.candidate1 == candidate || pair.candidate2 == candidate) {
          final other = (pair.candidate1 == candidate)
              ? pair.candidate2
              : pair.candidate1;

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
        candidateMap.keys, (node) => candidateMap[node]!)
      ..sort((a, b) {
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

    return CondorcetElection._internal(
      pairs,
      places.expand((p) => p).toList(growable: false),
      ballots,
      places,
    );
  }

  @override
  CondorcetPair<TCandidate> getPair(TCandidate c1, TCandidate c2) {
    assert(candidates.contains(c1));
    assert(candidates.contains(c2));

    return _pairs.singleWhere((p) => p.matches(c1, c2)).flip(c1);
  }
}

abstract class CondorcetElectionResult<TCandidate extends Comparable>
    implements ElectionResult<TCandidate, ElectionPlace<TCandidate>> {
  CondorcetPair<TCandidate> getPair(TCandidate c1, TCandidate c2);
}
