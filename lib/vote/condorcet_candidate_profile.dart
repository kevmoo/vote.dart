part of vote;

class CondorcetCandidateProfile<TCandidate extends Player>
  implements Hashable {

  final TCandidate candidate;
  final ReadOnlyCollection<TCandidate> lostTo;
  final ReadOnlyCollection<TCandidate> beat;
  final ReadOnlyCollection<TCandidate> tied;

  CondorcetCandidateProfile._internal(this.candidate, this.lostTo, this.beat, this.tied);

  int hashCode() => this.candidate.hashCode();

  String toString() => "[ $candidate: Beat: ${beat.length}, Tied: ${tied.length}, Lost to: ${lostTo.length}";
}
