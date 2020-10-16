import 'package:meta/meta.dart';

import 'ballot.dart';

@immutable
class ApprovalBallot<TCandidate extends Comparable> extends Ballot<TCandidate> {
  final Set<TCandidate> choices;

  ApprovalBallot(this.choices) : assert(choices.isNotEmpty);

  @override
  Iterable<TCandidate> referencedCandidates() => choices;

  @override
  String toString() => 'ApprovalBallot(${choices.join(' ,')})';
}
