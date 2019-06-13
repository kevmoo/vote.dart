import 'package:meta/meta.dart';

import 'election.dart';
import 'election_place.dart';
import 'irv_round.dart';
import 'ranked_ballot.dart';

@immutable
class IrvElection<TVoter, TCandidate extends Comparable>
    extends Election<TVoter, TCandidate> {
  @override
  final List<TCandidate> candidates;

  @override
  List<ElectionPlace<TCandidate>> get places => throw UnimplementedError();

  @override
  final List<RankedBallot<TVoter, TCandidate>> ballots;

  final List<IrvRound<TVoter, TCandidate>> rounds;

  const IrvElection._internal(this.candidates, this.ballots, this.rounds);

  factory IrvElection(List<RankedBallot<TVoter, TCandidate>> ballots) {
    final candidates =
        ballots.expand((b) => b.rank).toSet().toList(growable: false);

    final rounds = <IrvRound<TVoter, TCandidate>>[];

    IrvRound<TVoter, TCandidate> round;
    final eliminatedCandidates = <TCandidate>{};
    do {
      round = IrvRound<TVoter, TCandidate>(ballots, eliminatedCandidates);
      rounds.add(round);
      eliminatedCandidates.addAll(round.eliminatedCandidates);
    } while (!round.isFinal);

    return IrvElection._internal(candidates, ballots, rounds);
  }
}
