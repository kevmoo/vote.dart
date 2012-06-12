class Ballot<TVoter extends Hashable, TCandidate extends Hashable>
  implements Hashable {
  final TVoter voter;
  final TCandidate choice;

  Ballot(this.voter, this.choice);

  int hashCode(){
    return voter.hashCode();
  }
}
