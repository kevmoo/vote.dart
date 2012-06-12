class PluralityBallot<TVoter extends Hashable, TCandidate extends Hashable>
  extends Ballot {

  PluralityBallot(TVoter voter, TCandidate choice):super(voter, choice);

}
