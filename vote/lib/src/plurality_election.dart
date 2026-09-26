import 'package:meta/meta.dart';

import 'ballot.dart';
import 'election.dart';
import 'plurality_ballot.dart';
import 'plurality_election_place.dart';
import 'util.dart';

@immutable
class PluralityElection<TCandidate extends Comparable<Object>>._internal(
  List<Ballot<TCandidate>> ballots,
  List<TCandidate> candidates,
  List<PluralityElectionPlace<TCandidate>> places,
) extends Election<TCandidate, PluralityElectionPlace<TCandidate>> {
  this : super(candidates: candidates, ballots: ballots, places: places);

  factory(
    List<PluralityBallot<TCandidate>> ballots, {
    Iterable<TCandidate>? candidates,
  }) {
    final candidateVotes = <TCandidate, int>{};

    for (final ballot in ballots) {
      candidateVotes[ballot.choice] = (candidateVotes[ballot.choice] ?? 0) + 1;
    }

    final (candidates: candidateList, :places) = calculatePluralityPlaces(
      candidateVotes,
      candidates,
    );

    return PluralityElection._internal(ballots, candidateList, places);
  }
}
