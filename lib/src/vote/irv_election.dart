import 'ballot.dart';
import 'election.dart';
import 'irv_round.dart';
import 'ranked_ballot.dart';

class IrvElection extends Election {
  @override
  final List<Comparable> candidates;

  @override
  get places => throw new UnimplementedError();

  @override
  final List<Ballot> ballots;
  final List<IrvRound> rounds;

  IrvElection._internal(this.candidates, this.ballots, this.rounds);

  factory IrvElection(Iterable<RankedBallot> ballots) {
    final roBallots = new List<RankedBallot>.unmodifiable(ballots);

    final roCandidates = new List<Comparable>.unmodifiable(
        roBallots.expand((b) => b.rank).toSet());

    final rounds = new List<IrvRound>();

    IrvRound round;
    var eliminatedCandidates = new List();
    do {
      round = new IrvRound(roBallots, eliminatedCandidates);
      rounds.add(round);

      eliminatedCandidates.addAll(round.eliminatedCandidates.toList());
    } while (!round.isFinal);

    return new IrvElection._internal(
        roCandidates, roBallots, new List.unmodifiable(rounds));
  }
}
