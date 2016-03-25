import 'ballot.dart';
import 'election_place.dart';

abstract class Election<TVoter, TCandidate extends Comparable> {
  Iterable<TCandidate> get candidates;
  Iterable<Ballot<TVoter>> get ballots;
  List<ElectionPlace<TCandidate>> get places;

  TCandidate get singleWinner {
    if (places.length > 0 && places[0].length == 1) {
      return places[0][0];
    } else {
      return null;
    }
  }
}
