class Ballot<TVoter> {
  final TVoter voter;

  Ballot(this.voter);

  @override
  bool operator ==(Object other) => other is Ballot && other.voter == voter;

  @override
  int get hashCode => voter.hashCode;
}
