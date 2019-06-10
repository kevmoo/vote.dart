import 'package:meta/meta.dart';

import 'ballot.dart';

@immutable
class PluralityBallot<TVoter, TCandidate> extends Ballot<TVoter> {
  final TCandidate choice;

  const PluralityBallot(TVoter voter, this.choice) : super(voter);

  @override
  String toString() => 'PluralityBallot($choice)';
}
