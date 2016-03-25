class CondorcetCandidateProfile<TCandidate extends Comparable> {
  final TCandidate candidate;
  final List<TCandidate> lostTo;
  final List<TCandidate> beat;
  final List<TCandidate> tied;

  CondorcetCandidateProfile(this.candidate, this.lostTo, this.beat, this.tied);

  @override
  int get hashCode => this.candidate.hashCode;

  @override
  String toString() =>
      "[ $candidate: Beat: ${beat.length}, Tied: ${tied.length}, Lost to: ${lostTo.length}";
}
