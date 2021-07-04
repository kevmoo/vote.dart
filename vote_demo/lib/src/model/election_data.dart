import 'package:vote/vote.dart';
import 'package:vote_widgets/vote_widgets.dart';

abstract class ElectionData {
  ElectionData();

  factory ElectionData.fromData(
    List<RankedBallot<Candidate>> ballots, {
    List<Candidate> candidates,
  }) = _ElectionData;

  List<RankedBallot<Candidate>> get ballots;

  List<Candidate> get candidates;

  PluralityElection<Candidate>? _pluralityElection;

  PluralityElection<Candidate> get pluralityElection =>
      _pluralityElection ??= PluralityElection(ballots, candidates: candidates);

  CondorcetElection<Candidate>? _condorcetElection;

  CondorcetElection<Candidate> get condorcetElection =>
      _condorcetElection ??= CondorcetElection(ballots, candidates: candidates);

  IrvElection<Candidate>? _irvElection;

  IrvElection<Candidate> get irvElection =>
      _irvElection ??= IrvElection(ballots, candidates: candidates);
}

class _ElectionData extends ElectionData {
  @override
  final List<RankedBallot<Candidate>> ballots;

  @override
  final List<Candidate> candidates;

  _ElectionData(this.ballots, {List<Candidate>? candidates})
      : candidates = candidates ??
            ballots
                .expand((rb) => rb.referencedCandidates())
                .toList(growable: false);
}
