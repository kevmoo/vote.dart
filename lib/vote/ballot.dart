class Ballot<TVoter extends Player, TCandidate extends Player>
  implements Hashable {
  final TVoter voter;

  Ballot(this.voter);

  bool operator ==(Ballot other) => other !== null && other.voter == voter;

  int hashCode(){
    return voter.hashCode();
  }
}
