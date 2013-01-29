part of vote;

class IrvElection<TVoter extends Player, TCandidate extends Player>
  extends Election<TVoter, TCandidate> {

  final ReadOnlyCollection<TCandidate> candidates;
  final ReadOnlyCollection<Ballot<TVoter, TCandidate>> ballots;
  final ReadOnlyCollection<IrvRound<TVoter, TCandidate>> rounds;

  IrvElection._internal(this.candidates, this.ballots, this.rounds);

  factory IrvElection(Collection<RankedBallot<TVoter, TCandidate>> ballots) {
    final roBallots = new ReadOnlyCollection(ballots);

    final roCandidates = roBallots
        .selectMany((b) => b.rank)
        .distinct()
        .toReadOnlyCollection();

    final rounds = new List<IrvRound<TVoter, TCandidate>>();

    IrvRound<TVoter, TCandidate> round;
    List<TCandidate> eliminatedCandidates = new List<TCandidate>();
    do {
      round = new IrvRound<TVoter, TCandidate>(roBallots, eliminatedCandidates);
      rounds.add(round);

      eliminatedCandidates.addAll(round.eliminatedCandidates.toList());
    } while(!round.isFinal);

    return new IrvElection._internal(
      roCandidates,
      roBallots,
      new ReadOnlyCollection.wrap(rounds));
  }

  // TODO: need to add `places`
  // ReadOnlyCollection<ElectionPlace<TCandidate>> get places;
}
