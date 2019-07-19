import 'package:meta/meta.dart';

import 'ballot.dart';
import 'election_place.dart';

abstract class Election<TVoter, TCandidate extends Comparable,
    TElectionPlace extends ElectionPlace<TCandidate>> {
  Election({
    @required this.candidates,
    @required this.ballots,
    @required this.places,
  });

  final List<TCandidate> candidates;

  final List<Ballot<TVoter>> ballots;

  final List<TElectionPlace> places;

  TCandidate get singleWinner {
    if (places.isNotEmpty && places.first.length == 1) {
      return places.first.first;
    } else {
      return null;
    }
  }
}
