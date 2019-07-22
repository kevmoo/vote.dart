import 'package:vote/vote.dart';

import 'candidate.dart';
import 'voter.dart';

abstract class ElectionData {
  ElectionData();

  factory ElectionData.fromData(
    List<RankedBallot<Voter, Candidate>> ballots, {
    List<Candidate> candidates,
  }) = _ElectionData;

  List<RankedBallot<Voter, Candidate>> get ballots;

  List<Candidate> get candidates;

  PluralityElection<Voter, Candidate> _pluralityElection;

  PluralityElection<Voter, Candidate> get pluralityElection =>
      _pluralityElection ??= PluralityElection(ballots, candidates: candidates);

  CondorcetElection<Voter, Candidate> _condorcetElection;

  CondorcetElection<Voter, Candidate> get condorcetElection =>
      _condorcetElection ??= CondorcetElection(ballots);

  IrvElection<Voter, Candidate> _irvElection;

  IrvElection<Voter, Candidate> get irvElection =>
      _irvElection ??= IrvElection(ballots);
}

class _ElectionData extends ElectionData {
  @override
  final List<RankedBallot<Voter, Candidate>> ballots;

  @override
  final List<Candidate> candidates;

  _ElectionData(this.ballots, {List<Candidate> candidates})
      : candidates = candidates ??
            ballots
                .expand((rb) => rb.referencedCandidates())
                .toList(growable: false);
}
