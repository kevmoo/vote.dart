library vote.vote.irv_round;

import 'package:bot/bot.dart' hide ReadOnlyCollection;

import '../util.dart';
import 'player.dart';
import 'plurality_election_place.dart';
import 'irv_elimination.dart';
import 'ranked_ballot.dart';
import 'vote_util.dart';

class IrvRound<TVoter extends Player, TCandidate extends Player> {
  final ReadOnlyCollection<PluralityElectionPlace<TCandidate>> places;
  final ReadOnlyCollection<IrvElimination<TVoter, TCandidate>> eliminations;

  factory IrvRound(ReadOnlyCollection<RankedBallot<TVoter, TCandidate>> ballots,
      List<TCandidate> eliminatedCandidates) {
    var cleanedBallots = ballots.map((b) {
      var pruned =
          new ReadOnlyCollection($(b.rank).exclude(eliminatedCandidates));
      var winner = pruned.length == 0 ? null : pruned[0];
      return new Tuple3(b, pruned, winner);
    });

    final candidateAllocations = new Grouping(
        cleanedBallots.where((t) => t.item3 != null), (tuple) => tuple.item3);

    final voteGroups = new Grouping(candidateAllocations.getKeys(), (c) {
      return candidateAllocations[c].length;
    });

    final placeVotes = voteGroups.getKeys().toList();
    // reverse sorting -> most votes first
    placeVotes.sort((a, b) => b.compareTo(a));

    int placeNumber = 1;
    final places = new ReadOnlyCollection(placeVotes.map((pv) {
      final vg = voteGroups[pv];
      final currentPlaceNumber = placeNumber;
      placeNumber += vg.length;
      return new PluralityElectionPlace<TCandidate>(currentPlaceNumber, vg, pv);
    }));

    final newlyEliminatedCandidates = _getEliminatedCandidates(places);

    final eliminations = new ReadOnlyCollection(newlyEliminatedCandidates
        .map((c) {
      final xfers =
          new Map<TCandidate, List<RankedBallot<TVoter, TCandidate>>>();

      final exhausted = new List<RankedBallot<TVoter, TCandidate>>();

      for (final b in cleanedBallots.where((t) => t.item3 == c)) {
        final rb = b.item1;
        final pruned = $(b.item2).exclude(newlyEliminatedCandidates);
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
          c, xfers, new ReadOnlyCollection.wrap(exhausted));
    }));

    return new IrvRound._internal(places, eliminations);
  }

  IrvRound._internal(this.places, this.eliminations);

  bool get isFinal => eliminations.length == 0;

  Iterable<TCandidate> get eliminatedCandidates =>
      eliminations.map((ie) => ie.candidate);

  Iterable<TCandidate> get candidates => places.expand((p) => p);

  IrvElimination<TVoter, TCandidate> getElimination(TCandidate candidate) {
    return eliminations.singleWhere((e) => e.candidate == candidate);
  }

  static List<Player> _getEliminatedCandidates(
      ReadOnlyCollection<PluralityElectionPlace> places) {
    assert(places != null);
    assert(places.length > 0);

    if (places.length == 1) {
      // it's a tie for first
      return [];
    }

    // duh, I know. Being paranoid.
    assert(places.length >= 2);

    final int totalVotes = $(places).selectNumbers((p) {
      return p.voteCount * p.length;
    }).sum();

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
