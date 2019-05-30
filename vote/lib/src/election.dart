import 'ballot.dart';
import 'election_place.dart';

abstract class Election<TVoter, TCandidate extends Comparable> {
  Iterable<TCandidate> get candidates;

  Iterable<Ballot<TVoter>> get ballots;

  List<ElectionPlace<TCandidate>> get places;

  TCandidate get singleWinner {
    if (places.isNotEmpty && places.first.length == 1) {
      return places.first.first;
    } else {
      return null;
    }
  }
}
