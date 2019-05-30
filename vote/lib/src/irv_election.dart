import 'election.dart';
import 'election_place.dart';
import 'irv_round.dart';
import 'ranked_ballot.dart';

class IrvElection<TVoter, TCandidate> extends Election<TVoter, TCandidate> {
  @override
  final List<TCandidate> candidates;

  @override
  List<ElectionPlace<TCandidate>> get places => throw UnimplementedError();

  @override
  final List<RankedBallot<TVoter, TCandidate>> ballots;
  final List<IrvRound<TVoter, TCandidate>> rounds;

  IrvElection._internal(this.candidates, this.ballots, this.rounds);

  factory IrvElection(Iterable<RankedBallot<TVoter, TCandidate>> ballots) {
    final roBallots =
        List<RankedBallot<TVoter, TCandidate>>.unmodifiable(ballots);

    final roCandidates =
        List<TCandidate>.unmodifiable(roBallots.expand((b) => b.rank).toSet());

    final rounds = List<IrvRound<TVoter, TCandidate>>();

    IrvRound<TVoter, TCandidate> round;
    var eliminatedCandidates = List<TCandidate>();
    do {
      round = IrvRound<TVoter, TCandidate>(roBallots, eliminatedCandidates);
      rounds.add(round);

      eliminatedCandidates.addAll(round.eliminatedCandidates.toList());
    } while (!round.isFinal);

    return IrvElection._internal(
        roCandidates, roBallots, List.unmodifiable(rounds));
  }
}
