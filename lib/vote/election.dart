class Election<TVoter extends Player, TCandidate extends Player> {
  abstract Collection<TCandidate> get candidates();
  abstract Iterable<Ballot<TVoter, TCandidate>> get ballots();
  abstract ReadOnlyCollection<ElectionPlace<TCandidate>> get places();

  TCandidate get singleWinner {
    if(places.length > 0 && places[0].length == 1) {
      return places[0][0];
    }
    else {
      return null;
    }
  }
}
