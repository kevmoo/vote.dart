import 'package:meta/meta.dart';

import 'plurality_ballot.dart';
import 'util.dart';

@immutable
class RankedBallot<TVoter, TCandidate>
    implements PluralityBallot<TVoter, TCandidate> {
  @override
  final TVoter voter;

  @override
  TCandidate get choice => rank.first;

  final List<TCandidate> rank;

  RankedBallot(this.voter, this.rank)
      : assert(voter != null),
        assert(rank != null),
        assert(rank.isNotEmpty),
        assert(allUnique(rank));

  @override
  String toString() =>
      "{RankedBallot for '$voter', ranked ${rank.length} candidates}";

  @override
  bool operator ==(Object other) =>
      other is RankedBallot && other.voter == voter;

  @override
  int get hashCode => voter.hashCode;
}
