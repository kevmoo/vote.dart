import 'package:graphs/graphs.dart';
import 'package:meta/meta.dart';

import 'condorcet_pair.dart';
import 'election.dart';
import 'election_place.dart';
import 'ranked_ballot.dart';
import 'util.dart';

@immutable
class CondorcetElection<TVoter, TCandidate extends Comparable>
    extends Election<TVoter, TCandidate, ElectionPlace<TCandidate>> {
  final Set<CondorcetPair<TVoter, TCandidate>> _pairs;

  CondorcetElection._internal(
    this._pairs,
    List<TCandidate> candidates,
    List<RankedBallot<TVoter, TCandidate>> ballots,
    List<ElectionPlace<TCandidate>> places,
  ) : super(
          candidates: candidates,
          ballots: ballots,
          places: places,
        );

  factory CondorcetElection(List<RankedBallot<TVoter, TCandidate>> ballots) {
    // Check voter uniqueness
    final voterList = ballots.map((b) => b.voter).toList(growable: false);
    assert(allUnique(voterList), 'Only one ballot per voter is allowed');

    final map = <CondorcetPair<TVoter, TCandidate>,
        List<RankedBallot<TVoter, TCandidate>>>{};
    final candidateSet = <TCandidate>{};

    for (final ballot in ballots) {
      for (var i = 0; i < ballot.rank.length; i++) {
        final candidateI = ballot.rank[i];
        candidateSet.add(candidateI);

        for (var j = i + 1; j < ballot.rank.length; j++) {
          final pair =
              CondorcetPair<TVoter, TCandidate>(candidateI, ballot.rank[j]);

          map
              .putIfAbsent(pair, () => <RankedBallot<TVoter, TCandidate>>[])
              .add(ballot);
        }
      }
    }

    final pairs = map.entries
        .map((entry) => CondorcetPair<TVoter, TCandidate>(
            entry.key.candidate1, entry.key.candidate2, entry.value))
        .toSet();

    final candidateProfiles =
        <TCandidate, _CondorcetCandidateProfile<TCandidate>>{};
    final candidateMap = <TCandidate, Set<TCandidate>>{};

    for (final candidate in candidateSet) {
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

      candidateProfiles[candidate] = _CondorcetCandidateProfile<TCandidate>(
        candidate,
        lostTo..sort(),
        beat..sort(),
        tied..sort(),
      );

      candidateMap[candidate] = lostTiedSet;
    }

    final components = stronglyConnectedComponents<TCandidate>(
        candidateMap.keys, (node) => candidateMap[node]);

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

  CondorcetPair<TVoter, TCandidate> getPair(TCandidate c1, TCandidate c2) {
    assert(candidates.contains(c1));
    assert(candidates.contains(c2));
    final filter = _pairs.where((p) => p.matches(c1, c2));
    assert(filter.length <= 1);
    if (filter.isEmpty) {
      return null;
    } else {
      assert(filter.length == 1);
      return filter.first.flip(c1, c2);
    }
  }
}

class _CondorcetCandidateProfile<TCandidate extends Comparable> {
  final TCandidate candidate;
  final List<TCandidate> lostTo;
  final List<TCandidate> beat;
  final List<TCandidate> tied;

  _CondorcetCandidateProfile(this.candidate, this.lostTo, this.beat, this.tied)
      : assert(sorted(lostTo)),
        assert(sorted(beat)),
        assert(sorted(tied));

  @override
  String toString() => '[ $candidate: '
      'Beat: ${beat.length}, '
      'Tied: ${tied.length}, '
      'Lost to: ${lostTo.length} ]';
}
