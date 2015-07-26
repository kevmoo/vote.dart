library vote.vote.irv_election;

import 'package:bot/bot.dart' hide ReadOnlyCollection;

import '../util.dart';
import 'player.dart';
import 'ballot.dart';
import 'irv_round.dart';
import 'election.dart';
import 'ranked_ballot.dart';

class IrvElection<TVoter extends Player, TCandidate extends Player>
    extends Election<TVoter, TCandidate> {
  final ReadOnlyCollection<TCandidate> candidates;
  final ReadOnlyCollection<Ballot<TVoter, TCandidate>> ballots;
  final ReadOnlyCollection<IrvRound<TVoter, TCandidate>> rounds;

  IrvElection._internal(this.candidates, this.ballots, this.rounds);

  factory IrvElection(Iterable<RankedBallot<TVoter, TCandidate>> ballots) {
    final roBallots = new ReadOnlyCollection(ballots);

    final roCandidates =
        new ReadOnlyCollection($(roBallots).expand((b) => b.rank).distinct());

    final rounds = new List<IrvRound<TVoter, TCandidate>>();

    IrvRound<TVoter, TCandidate> round;
    List<TCandidate> eliminatedCandidates = new List<TCandidate>();
    do {
      round = new IrvRound<TVoter, TCandidate>(roBallots, eliminatedCandidates);
      rounds.add(round);

      eliminatedCandidates.addAll(round.eliminatedCandidates.toList());
    } while (!round.isFinal);

    return new IrvElection._internal(
        roCandidates, roBallots, new ReadOnlyCollection.wrap(rounds));
  }

  // TODO: need to add `places`
  // ReadOnlyCollection<ElectionPlace<TCandidate>> get places;
}
