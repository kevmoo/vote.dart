library vote.vote.election;

import 'player.dart';
import 'ballot.dart';

import 'election_place.dart';

abstract class Election<TVoter extends Player, TCandidate extends Player> {
  Iterable<TCandidate> get candidates;
  Iterable<Ballot<TVoter, TCandidate>> get ballots;
  List<ElectionPlace<TCandidate>> get places;

  TCandidate get singleWinner {
    if (places.length > 0 && places[0].length == 1) {
      return places[0][0];
    } else {
      return null;
    }
  }
}
