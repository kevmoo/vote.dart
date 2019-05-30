import 'package:collection/collection.dart';

import 'irv_elimination.dart';
import 'plurality_election_place.dart';
import 'ranked_ballot.dart';
import 'vote_util.dart';

class IrvRound<TVoter, TCandidate> {
  final List<PluralityElectionPlace<TCandidate>> places;
  final List<IrvElimination<TVoter, TCandidate>> eliminations;

  factory IrvRound(List<RankedBallot<TVoter, TCandidate>> ballots,
      List<TCandidate> eliminatedCandidates) {
    var cleanedBallots = ballots.map((b) {
      var pruned = List<TCandidate>.unmodifiable(
          b.rank.toList()..removeWhere(eliminatedCandidates.contains));
      var winner = pruned.isEmpty ? null : pruned[0];
      return _Tuple3<TVoter, TCandidate>(b, pruned, winner);
    });

    final candidateAllocations =
        groupBy<_Tuple3<TVoter, TCandidate>, TCandidate>(
            cleanedBallots.where((t) => t.winner != null),
            (tuple) => tuple.winner);

    final voteGroups = groupBy<TCandidate, int>(candidateAllocations.keys, (c) {
      return candidateAllocations[c].length;
    });

    final placeVotes = voteGroups.keys.toList();
    // reverse sorting -> most votes first
    placeVotes.sort((a, b) => b.compareTo(a));

    int placeNumber = 1;
    final places = List<PluralityElectionPlace<TCandidate>>.unmodifiable(
        placeVotes.map((pv) {
      final vg = voteGroups[pv];
      final currentPlaceNumber = placeNumber;
      placeNumber += vg.length;
      return PluralityElectionPlace<TCandidate>(currentPlaceNumber, vg, pv);
    }));

    final newlyEliminatedCandidates =
        _getEliminatedCandidates<TCandidate>(places);

    final eliminations = List<IrvElimination<TVoter, TCandidate>>.unmodifiable(
        newlyEliminatedCandidates.map((TCandidate c) {
      final xfers = Map<TCandidate, List<RankedBallot<TVoter, TCandidate>>>();

      final exhausted = List<RankedBallot<TVoter, TCandidate>>();

      for (var b in cleanedBallots.where((t) => t.winner == c)) {
        final rb = b.ballot;
        final pruned = b.remaining.toList()
          ..removeWhere(newlyEliminatedCandidates.contains);
        if (pruned.isEmpty) {
          // we're exhausted
          exhausted.add(rb);
        } else {
          // #2 gets the transfer
          final runnerUp = pruned.first;
          xfers.putIfAbsent(runnerUp, () => List()).add(rb);
        }
      }

      return IrvElimination<TVoter, TCandidate>(
          c, xfers, List.unmodifiable(exhausted));
    }));

    return IrvRound<TVoter, TCandidate>._internal(places, eliminations);
  }

  IrvRound._internal(this.places, this.eliminations);

  bool get isFinal => eliminations.isEmpty;

  Iterable<TCandidate> get eliminatedCandidates =>
      eliminations.map((ie) => ie.candidate);

  Iterable<TCandidate> get candidates => places.expand((p) => p);

  IrvElimination<TVoter, TCandidate> getElimination(TCandidate candidate) {
    return eliminations.singleWhere((e) => e.candidate == candidate);
  }

  static List<TCandidate> _getEliminatedCandidates<TCandidate>(
      List<PluralityElectionPlace<TCandidate>> places) {
    assert(places != null);
    assert(places.isNotEmpty);

    if (places.length == 1) {
      // it's a tie for first
      return [];
    }

    // duh, I know. Being paranoid.
    assert(places.length >= 2);

    final int totalVotes = places.map((p) {
      return p.voteCount * p.length;
    }).fold(0, (a, b) => a + b);

    final majorityCount = majorityThreshold(totalVotes);

    //
    // eliminations
    //
    // 2 or more 'places'
    // unless
    // a) first place is single candiadate
    // b) first place votes > (0.5 * total + 1)
    if (places[0].length == 1 && places[0].voteCount >= majorityCount) {
      return [];
    }

    return places.last.map((p) => p).toList();
  }
}

class _Tuple3<TVoter, TCandidate> {
  final RankedBallot<TVoter, TCandidate> ballot;
  final List<TCandidate> remaining;
  final TCandidate winner;

  _Tuple3(this.ballot, this.remaining, this.winner);
}
