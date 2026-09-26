import 'package:meta/meta.dart';

import 'approval_ballot.dart';
import 'ballot.dart';
import 'election.dart';
import 'plurality_election_place.dart';
import 'util.dart';

@immutable
class ApprovalElection<TCandidate extends Comparable<Object>>._internal(
  List<Ballot<TCandidate>> ballots,
  List<TCandidate> candidates,
  List<PluralityElectionPlace<TCandidate>> places,
) extends Election<TCandidate, PluralityElectionPlace<TCandidate>> {
  this : super(candidates: candidates, ballots: ballots, places: places);

  factory(
    List<ApprovalBallot<TCandidate>> ballots, {
    Iterable<TCandidate>? candidates,
  }) {
    final candidateVotes = <TCandidate, int>{};

    for (final ballot in ballots) {
      for (final candidate in ballot.choices) {
        candidateVotes[candidate] = (candidateVotes[candidate] ?? 0) + 1;
      }
    }

    final (candidates: candidateList, :places) = calculatePluralityPlaces(
      candidateVotes,
      candidates,
    );

    return ApprovalElection._internal(ballots, candidateList, places);
  }
}
