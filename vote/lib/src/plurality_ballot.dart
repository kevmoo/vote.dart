import 'package:meta/meta.dart';

import 'ballot.dart';

@immutable
class const PluralityBallot<TCandidate extends Comparable<dynamic>>(
  final TCandidate choice,
) extends Ballot<TCandidate> {
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
