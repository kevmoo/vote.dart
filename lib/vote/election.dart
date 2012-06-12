interface Election<TVoter extends Player, TCandidate extends Player> {
  Iterable<TVoter> get voters();
  Iterable<Ballot<TVoter, TCandidate>> get ballots();
}
