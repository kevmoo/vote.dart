import 'ballot.dart';
import 'election.dart';
import 'irv_round.dart';
import 'ranked_ballot.dart';

class IrvElection extends Election {
  @override
  final List<Comparable> candidates;

  @override
  get places => throw UnimplementedError();

  @override
  final List<Ballot> ballots;
  final List<IrvRound> rounds;

  IrvElection._internal(this.candidates, this.ballots, this.rounds);

  factory IrvElection(Iterable<RankedBallot> ballots) {
    final roBallots = List<RankedBallot>.unmodifiable(ballots);

    final roCandidates =
        List<Comparable>.unmodifiable(roBallots.expand((b) => b.rank).toSet());

    final rounds = List<IrvRound>();

    IrvRound round;
    var eliminatedCandidates = List();
    do {
      round = IrvRound(roBallots, eliminatedCandidates);
      rounds.add(round);

      eliminatedCandidates.addAll(round.eliminatedCandidates.toList());
    } while (!round.isFinal);

    return IrvElection._internal(
        roCandidates, roBallots, List.unmodifiable(rounds));
  }
}
