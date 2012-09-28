abstract class Election<TVoter extends Player, TCandidate extends Player> {
  Collection<TCandidate> get candidates;
  Iterable<Ballot<TVoter, TCandidate>> get ballots;
  ReadOnlyCollection<ElectionPlace<TCandidate>> get places;

  TCandidate get singleWinner {
    if(places.length > 0 && places[0].length == 1) {
      return places[0][0];
    }
    else {
      return null;
    }
  }
}
