class Ballot<TVoter extends Player, TCandidate extends Player>
  implements Hashable {
  final TVoter voter;

  Ballot(this.voter);

  int hashCode(){
    return voter.hashCode();
  }
}
