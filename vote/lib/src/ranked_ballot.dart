import 'package:meta/meta.dart';

import 'plurality_ballot.dart';
import 'util.dart';

@immutable
class RankedBallot<TVoter, TCandidate>
    extends PluralityBallot<TVoter, TCandidate> {
  final List<TCandidate> rank;

  RankedBallot(TVoter voter, this.rank)
      : assert(voter != null),
        assert(rank != null),
        assert(rank.isNotEmpty),
        assert(allUnique(rank)),
        super(voter, rank[0]);

  @override
  String toString() =>
      "{RankedBallot for '$voter', ranked ${rank.length} candidates}";
}
