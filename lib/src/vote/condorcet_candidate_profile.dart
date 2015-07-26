library vote.vote.condorcet_candidate_profile;

import '../util.dart';
import 'player.dart';

class CondorcetCandidateProfile<TCandidate extends Player> {
  final TCandidate candidate;
  final ReadOnlyCollection<TCandidate> lostTo;
  final ReadOnlyCollection<TCandidate> beat;
  final ReadOnlyCollection<TCandidate> tied;

  CondorcetCandidateProfile(
      this.candidate, this.lostTo, this.beat, this.tied);

  int get hashCode => this.candidate.hashCode;

  String toString() =>
      "[ $candidate: Beat: ${beat.length}, Tied: ${tied.length}, Lost to: ${lostTo.length}";
}
