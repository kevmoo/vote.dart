library vote.vote.condorcet_candidate_profile;

import 'player.dart';

class CondorcetCandidateProfile<TCandidate extends Player> {
  final TCandidate candidate;
  final List<TCandidate> lostTo;
  final List<TCandidate> beat;
  final List<TCandidate> tied;

  CondorcetCandidateProfile(this.candidate, this.lostTo, this.beat, this.tied);

  int get hashCode => this.candidate.hashCode;

  String toString() =>
      "[ $candidate: Beat: ${beat.length}, Tied: ${tied.length}, Lost to: ${lostTo.length}";
}
