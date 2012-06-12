interface Election<TVoter extends Hashable, TCandidate extends Hashable> {
  Iterable<TVoter> get voters();
  Iterable<Ballot<TVoter, TCandidate>> get ballots();
}
