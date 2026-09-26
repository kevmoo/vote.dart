import 'package:meta/meta.dart';

import 'approval_ballot.dart';
import 'ballot.dart';
import 'election.dart';
import 'plurality_election_place.dart';
import 'util.dart';

@immutable
class ApprovalElection<TCandidate extends Comparable<dynamic>>
    extends Election<TCandidate, PluralityElectionPlace<TCandidate>> {
  ApprovalElection._internal(
    List<Ballot<TCandidate>> ballots,
    List<TCandidate> candidates,
    List<PluralityElectionPlace<TCandidate>> places,
  ) : super(candidates: candidates, ballots: ballots, places: places);

  factory ApprovalElection(
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
