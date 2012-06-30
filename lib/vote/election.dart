interface Election<TVoter extends Player, TCandidate extends Player> {
  Collection<TCandidate> get candidates();
  Collection<Ballot<TVoter, TCandidate>> get ballots();
  TCandidate get singleWinner();
  ReadOnlyCollection<ElectionPlace<TCandidate>> get places();
}
