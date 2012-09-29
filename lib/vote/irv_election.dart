class IrvElection<TVoter extends Player, TCandidate extends Player>
  extends Election<TVoter, TCandidate> {

  final ReadOnlyCollection<TCandidate> candidates;
  final ReadOnlyCollection<Ballot<TVoter, TCandidate>> ballots;
  final ReadOnlyCollection<ElectionPlace<TCandidate>> places;
  final ReadOnlyCollection<IrvRound<TVoter, TCandidate>> rounds;

  IrvElection._internal(this.candidates, this.ballots, this.places, this.rounds);

  factory IrvElection(Collection<RankedBallot<TVoter, TCandidate>> ballots) {
    final roBallots = $(ballots).toReadOnlyCollection();

    final roCandidates = roBallots
        .selectMany((b) => b.rank)
        .distinct()
        .toReadOnlyCollection();

    final rounds = new List<IrvRound<TVoter, TCandidate>>();

    var round = new IrvRound<TVoter, TCandidate>(roBallots, $([]));

    return new IrvElection._internal(
      roCandidates,
      roBallots,
      $([]).toReadOnlyCollection(),
      $([round]).toReadOnlyCollection());
  }

}
