import 'package:tuple/tuple.dart';

import 'irv_elimination.dart';
import 'plurality_election_place.dart';
import 'ranked_ballot.dart';
import 'vote_util.dart';

import '../grouping.dart';

class IrvRound<TVoter, TCandidate> {
  final List<PluralityElectionPlace<TCandidate>> places;
  final List<IrvElimination<TVoter, TCandidate>> eliminations;

  factory IrvRound(List<RankedBallot<TVoter, TCandidate>> ballots,
      List<TCandidate> eliminatedCandidates) {
    var cleanedBallots = ballots.map((b) {
      var pruned = new List.unmodifiable(
          b.rank.toList()..removeWhere(eliminatedCandidates.contains));
      var winner = pruned.length == 0 ? null : pruned[0];
      return new Tuple3<RankedBallot<TVoter, TCandidate>, List, dynamic>(
          b, pruned, winner);
    });

    final candidateAllocations = new Grouping<TCandidate, Tuple3>(
        cleanedBallots.where((t) => t.item3 != null), (tuple) => tuple.item3);

    final voteGroups =
        new Grouping<int, TCandidate>(candidateAllocations.getKeys(), (c) {
      return candidateAllocations[c].length;
    });

    final placeVotes = voteGroups.getKeys().toList();
    // reverse sorting -> most votes first
    placeVotes.sort((a, b) => b.compareTo(a));

    int placeNumber = 1;
    final places =
        new List<PluralityElectionPlace>.unmodifiable(placeVotes.map((pv) {
      final vg = voteGroups[pv];
      final currentPlaceNumber = placeNumber;
      placeNumber += vg.length;
      return new PluralityElectionPlace<TCandidate>(currentPlaceNumber, vg, pv);
    }));

    final newlyEliminatedCandidates = _getEliminatedCandidates(places);

    final eliminations = new List<IrvElimination>.unmodifiable(
        newlyEliminatedCandidates.map((TCandidate c) {
      final xfers =
          new Map<TCandidate, List<RankedBallot<TVoter, TCandidate>>>();

      final exhausted = new List<RankedBallot<TVoter, TCandidate>>();

      for (Tuple3<RankedBallot<TVoter, TCandidate>, List, dynamic> b
          in cleanedBallots.where((t) => t.item3 == c)) {
        final rb = b.item1;
        final pruned = b.item2.toList()
          ..removeWhere(newlyEliminatedCandidates.contains);
        if (pruned.isEmpty) {
          // we're exhausted
          exhausted.add(rb);
        } else {
          // #2 gets the transfer
          final runnerUp = pruned.first;
          xfers.putIfAbsent(runnerUp, () => new List()).add(rb);
        }
      }

      return new IrvElimination<TVoter, TCandidate>(
          c, xfers, new List.unmodifiable(exhausted));
    }));

    return new IrvRound<TVoter, TCandidate>._internal(places, eliminations);
  }

  IrvRound._internal(this.places, this.eliminations);

  bool get isFinal => eliminations.length == 0;

  Iterable<TCandidate> get eliminatedCandidates =>
      eliminations.map((ie) => ie.candidate);

  Iterable<TCandidate> get candidates => places.expand((p) => p);

  IrvElimination<TVoter, TCandidate> getElimination(TCandidate candidate) {
    return eliminations.singleWhere((e) => e.candidate == candidate);
  }

  static List _getEliminatedCandidates(List<PluralityElectionPlace> places) {
    assert(places != null);
    assert(places.length > 0);

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

    // DARTBUG https://code.google.com/p/dart/issues/detail?id=7085
    // last() seems to be f'd up when compiled
    return places[places.length - 1].map((p) => p).toList();
  }
}
