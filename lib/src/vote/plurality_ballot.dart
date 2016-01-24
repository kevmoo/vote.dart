import 'ballot.dart';
import 'player.dart';

class PluralityBallot<TVoter extends Player, TCandidate extends Player>
    extends Ballot {
  final TCandidate choice;

  PluralityBallot(TVoter voter, this.choice) : super(voter);
}
