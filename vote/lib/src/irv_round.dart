import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import 'irv_elimination.dart';
import 'plurality_election_place.dart';
import 'ranked_ballot.dart';
import 'util.dart';

@immutable
class IrvRound<TCandidate extends Comparable> {
  /// 1-indexed number of the round.
  ///
  /// The first round in an election is `1` and so on.
  final int number;

  final List<PluralityElectionPlace<TCandidate>> places;

  final List<IrvElimination<TCandidate>> eliminations;

  bool get isFinal => eliminations.isEmpty;

  Iterable<TCandidate> get eliminatedCandidates =>
      eliminations.map((ie) => ie.candidate);

  Iterable<TCandidate> get candidates => places.expand((p) => p);

  const IrvRound._internal(this.number, this.places, this.eliminations)
      : assert(number > 0);

  factory IrvRound(
    int roundNumber,
    List<RankedBallot<TCandidate>> ballots,
    Iterable<TCandidate> eliminatedCandidates,
  ) {
    final cleanedBallots = ballots.map((b) {
      final pruned = b.rank
          .where((c) => !eliminatedCandidates.contains(c))
          .toList(growable: false);
      final winner = pruned.isEmpty ? null : pruned[0];
      return _CleanedBallot<TCandidate>(b, pruned, winner);
    });

    final candidateAllocations =
        groupBy<_CleanedBallot<TCandidate>, TCandidate>(
      cleanedBallots.where((cb) => cb.winner != null),
      (cb) => cb.winner!,
    );

    final voteGroups = groupBy<TCandidate, int>(
      candidateAllocations.keys,
      (c) => candidateAllocations[c]!.length,
    );

    final placeVotes = voteGroups.keys.toList(growable: false)
      // reverse sorting -> most votes first
      ..sort((a, b) => b.compareTo(a));

    var placeNumber = 1;
    final places = placeVotes.map((vote) {
      final voteGroup = voteGroups[vote]!..sort();
      final currentPlaceNumber = placeNumber;
      placeNumber += voteGroup.length;
      return PluralityElectionPlace<TCandidate>(
        currentPlaceNumber,
        voteGroup,
        vote,
      );
    }).toList(growable: false);

    final newlyEliminatedCandidates =
        _getEliminatedCandidates<TCandidate>(places);

    final eliminations = newlyEliminatedCandidates.map((TCandidate c) {
      final transfers = <TCandidate, List<RankedBallot<TCandidate>>>{};

      final exhausted = <RankedBallot<TCandidate>>[];

      for (var cb in cleanedBallots.where((cb) => cb.winner == c)) {
        final rb = cb.ballot;
        final pruned =
            cb.remaining.where((c) => !newlyEliminatedCandidates.contains(c));
        if (pruned.isEmpty) {
          // we're exhausted
          exhausted.add(rb);
        } else {
          // #2 gets the transfer
          final runnerUp = pruned.first;
          transfers.putIfAbsent(runnerUp, () => []).add(rb);
        }
      }

      return IrvElimination<TCandidate>(c, transfers, exhausted);
    }).toList(growable: false);

    return IrvRound<TCandidate>._internal(
      roundNumber,
      places,
      eliminations,
    );
  }

  IrvElimination<TCandidate>? eliminationForCandidate(TCandidate candidate) =>
      eliminations.cast<IrvElimination<TCandidate>?>().singleWhere(
            (e) => e?.candidate == candidate,
            orElse: () => null,
          );

  static List<TCandidate>
      _getEliminatedCandidates<TCandidate extends Comparable>(
    List<PluralityElectionPlace<TCandidate>> places,
  ) {
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

class _CleanedBallot<TCandidate extends Comparable> {
  final RankedBallot<TCandidate> ballot;
  final List<TCandidate> remaining;
  final TCandidate? winner;

  const _CleanedBallot(this.ballot, this.remaining, this.winner);
}
