interface Election<TVoter extends Player, TCandidate extends Player> {
  Iterable<TCandidate> get candidates();
  Iterable<Ballot<TVoter, TCandidate>> get ballots();
  TCandidate get singleWinner();
  ReadOnlyCollection<ElectionPlace<TCandidate>> get places();
}
