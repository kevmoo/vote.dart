part of vote;

class Ballot<TVoter extends Player, TCandidate extends Player> {
  final TVoter voter;

  Ballot(this.voter);

  bool operator ==(Ballot other) => other != null && other.voter == voter;

  int get hashCode => voter.hashCode;
}
