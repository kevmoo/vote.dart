import 'ballot.dart';

class PluralityBallot<TVoter, TCandidate> extends Ballot<TVoter> {
  final TCandidate choice;

  PluralityBallot(TVoter voter, this.choice) : super(voter);
}
