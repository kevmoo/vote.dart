import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import 'irv_elimination.dart';
import 'plurality_election_place.dart';
import 'ranked_ballot.dart';
import 'util.dart';

@immutable
class IrvRound<TVoter, TCandidate extends Comparable> {
  final List<PluralityElectionPlace<TCandidate>> places;

  final List<IrvElimination<TVoter, TCandidate>> eliminations;

  bool get isFinal => eliminations.isEmpty;

  Iterable<TCandidate> get eliminatedCandidates =>
      eliminations.map((ie) => ie.candidate);

  Iterable<TCandidate> get candidates => places.expand((p) => p);

  const IrvRound._internal(this.places, this.eliminations);

  factory IrvRound(
    List<RankedBallot<TVoter, TCandidate>> ballots,
    Iterable<TCandidate> eliminatedCandidates,
  ) {
    final cleanedBallots = ballots.map((b) {
      final pruned = b.rank
          .where((c) => !eliminatedCandidates.contains(c))
          .toList(growable: false);
      final winner = pruned.isEmpty ? null : pruned[0];
      return _Tuple3<TVoter, TCandidate>(b, pruned, winner);
    });

    final candidateAllocations =
        groupBy<_Tuple3<TVoter, TCandidate>, TCandidate>(
            cleanedBallots.where((t) => t.winner != null),
            (tuple) => tuple.winner);

    final voteGroups = groupBy<TCandidate, int>(
        candidateAllocations.keys, (c) => candidateAllocations[c].length);

    final placeVotes = voteGroups.keys.toList(growable: false)
      // reverse sorting -> most votes first
      ..sort((a, b) => b.compareTo(a));

    var placeNumber = 1;
    final places = placeVotes.map((pv) {
      final vg = voteGroups[pv];
      final currentPlaceNumber = placeNumber;
      placeNumber += vg.length;
      return PluralityElectionPlace<TCandidate>(currentPlaceNumber, vg, pv);
    }).toList(growable: false);

    final newlyEliminatedCandidates =
        _getEliminatedCandidates<TCandidate>(places);

    final eliminations = newlyEliminatedCandidates.map((TCandidate c) {
      final transfers = <TCandidate, List<RankedBallot<TVoter, TCandidate>>>{};

      final exhausted = <RankedBallot<TVoter, TCandidate>>[];

      for (var b in cleanedBallots.where((t) => t.winner == c)) {
        final rb = b.ballot;
        final pruned =
            b.remaining.where((c) => !newlyEliminatedCandidates.contains(c));
        if (pruned.isEmpty) {
          // we're exhausted
          exhausted.add(rb);
        } else {
          // #2 gets the transfer
          final runnerUp = pruned.first;
          transfers.putIfAbsent(runnerUp, () => []).add(rb);
        }
      }

      return IrvElimination<TVoter, TCandidate>(c, transfers, exhausted);
    }).toList(growable: false);

    return IrvRound<TVoter, TCandidate>._internal(places, eliminations);
  }

  IrvElimination<TVoter, TCandidate> eliminationForCandidate(
          TCandidate candidate) =>
      eliminations.singleWhere((e) => e.candidate == candidate);

  static List<TCandidate>
      _getEliminatedCandidates<TCandidate extends Comparable>(
          List<PluralityElectionPlace<TCandidate>> places) {
    assert(places != null);
    assert(places.isNotEmpty);

    if (places.length == 1) {
      // it's a tie for first
      return [];
    }

    // duh, I know. Being paranoid.
    assert(places.length >= 2);

    final totalVotes =
        places.map((p) => p.voteCount * p.length).fold<int>(0, (a, b) => a + b);

    final majorityCount = majorityThreshold(totalVotes);

    //
    // eliminations
    //
    // 2 or more 'places'
    // unless
    // a) first place is single candidate
    // b) first place votes > (0.5 * total + 1)
    if (places[0].length == 1 && places[0].voteCount >= majorityCount) {
      return [];
    }

    return places.last.map((p) => p).toList(growable: false);
  }
}

class _Tuple3<TVoter, TCandidate> {
  final RankedBallot<TVoter, TCandidate> ballot;
  final List<TCandidate> remaining;
  final TCandidate winner;

  const _Tuple3(this.ballot, this.remaining, this.winner);
}
