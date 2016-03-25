class Ballot<TVoter> {
  final TVoter voter;

  Ballot(this.voter);

  @override
  bool operator ==(Ballot other) => other != null && other.voter == voter;

  @override
  int get hashCode => voter.hashCode;
}
