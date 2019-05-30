import 'package:meta/meta.dart';

import 'plurality_ballot.dart';
import 'util.dart';

@immutable
class RankedBallot<TVoter, TCandidate>
    extends PluralityBallot<TVoter, TCandidate> {
  final List<TCandidate> rank;

  RankedBallot._(TVoter voter, this.rank) : super(voter, rank[0]);

  factory RankedBallot(TVoter voter, Iterable<TCandidate> rank) {
    requireArgumentNotNull(voter, 'voter');
    requireArgumentNotNull(rank, 'rank');

    final items = List<TCandidate>.unmodifiable(rank);
    requireArgument(items.isNotEmpty, 'rank');
    requireArgument(allUnique(items), 'rank');

    return RankedBallot._(voter, items);
  }

  @override
  String toString() =>
      "{RankedBallot for '$voter', ranked ${rank.length} candidates}";
}
