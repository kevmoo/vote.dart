class Ballot<TVoter extends Player, TCandidate extends Player>
  implements Hashable {
  final TVoter voter;
  final TCandidate choice;

  Ballot(this.voter, this.choice);

  int hashCode(){
    return voter.hashCode();
  }
}
