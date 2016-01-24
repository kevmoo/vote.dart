import 'package:bot/bot.dart' hide ReadOnlyCollection;

import 'player.dart';
import 'ballot.dart';
import 'irv_round.dart';
import 'election.dart';
import 'ranked_ballot.dart';

class IrvElection<TVoter extends Player, TCandidate extends Player>
    extends Election<TVoter, TCandidate> {
  final List<TCandidate> candidates;
  final List<Ballot<TVoter, TCandidate>> ballots;
  final List<IrvRound<TVoter, TCandidate>> rounds;

  IrvElection._internal(this.candidates, this.ballots, this.rounds);

  factory IrvElection(Iterable<RankedBallot<TVoter, TCandidate>> ballots) {
    final roBallots = new List.unmodifiable(ballots);

    final roCandidates =
        new List.unmodifiable($(roBallots).expand((b) => b.rank).distinct());

    final rounds = new List<IrvRound<TVoter, TCandidate>>();

    IrvRound<TVoter, TCandidate> round;
    List<TCandidate> eliminatedCandidates = new List<TCandidate>();
    do {
      round = new IrvRound<TVoter, TCandidate>(roBallots, eliminatedCandidates);
      rounds.add(round);

      eliminatedCandidates.addAll(round.eliminatedCandidates.toList());
    } while (!round.isFinal);

    return new IrvElection._internal(
        roCandidates, roBallots, new List.unmodifiable(rounds));
  }

  // TODO: need to add `places`
  // ReadOnlyCollection<ElectionPlace<TCandidate>> get places;
}
