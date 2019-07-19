import 'package:meta/meta.dart';

import 'ballot.dart';

@immutable
class PluralityBallot<TVoter, TCandidate> extends Ballot<TVoter, TCandidate> {
  final TCandidate choice;

  const PluralityBallot(TVoter voter, this.choice) : super(voter);

  @override
  Iterable<TCandidate> referencedCandidates() => [choice];

  @override
  String toString() => 'PluralityBallot($choice)';
}
