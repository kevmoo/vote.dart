import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import 'ballot.dart';

@immutable
class ApprovalBallot<TCandidate extends Comparable<dynamic>>(
  final Set<TCandidate> choices,
) extends Ballot<TCandidate> {
  this : assert(choices.isNotEmpty);

  @override
  Iterable<TCandidate> referencedCandidates() => choices;

  @override
  String toString() => 'ApprovalBallot(${choices.join(', ')})';

  @override
  bool operator ==(Object other) =>
      other is ApprovalBallot<TCandidate> &&
      const SetEquality<Object>().equals(other.choices, choices);

  @override
  int get hashCode => const SetEquality<Object>().hash(choices);
}
