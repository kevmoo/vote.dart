import 'package:meta/meta.dart';

import 'ballot.dart';

@immutable
class PluralityBallot<TCandidate extends Comparable>
    extends Ballot<TCandidate> {
  final TCandidate choice;

  const PluralityBallot(this.choice);

  @override
  Iterable<TCandidate> referencedCandidates() => [choice];

  @override
  String toString() => 'PluralityBallot($choice)';

  @override
  bool operator ==(Object other) =>
      other is PluralityBallot<TCandidate> && other.choice == choice;

  @override
  int get hashCode => choice.hashCode;
}
