import 'plurality_ballot.dart';

import '../util.dart';

class RankedBallot<TVoter, TCandidate>
    extends PluralityBallot<TVoter, TCandidate> {
  final List<TCandidate> rank;

  RankedBallot.protected(TVoter voter, List<TCandidate> items)
      : rank = items,
        super(voter, items[0]);

  factory RankedBallot(TVoter voter, Iterable<TCandidate> rank) {
    requireArgumentNotNull(voter, 'voter');
    requireArgumentNotNull(rank, 'rank');

    var items = new List<TCandidate>.unmodifiable(rank);
    requireArgument(items.length > 0, 'rank');
    requireArgument(allUnique(items), 'rank');

    return new RankedBallot.protected(voter, items);
  }

  @override
  String toString() =>
      "{RankedBallot for '$voter', ranked ${rank.length} candidates}";
}
