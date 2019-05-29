import '../util.dart';
import 'plurality_ballot.dart';

class RankedBallot<TVoter, TCandidate>
    extends PluralityBallot<TVoter, TCandidate> {
  final List<TCandidate> rank;

  RankedBallot.protected(TVoter voter, List<TCandidate> items)
      : rank = items,
        super(voter, items[0]);

  factory RankedBallot(TVoter voter, Iterable<TCandidate> rank) {
    requireArgumentNotNull(voter, 'voter');
    requireArgumentNotNull(rank, 'rank');

    var items = List<TCandidate>.unmodifiable(rank);
    requireArgument(items.isNotEmpty, 'rank');
    requireArgument(allUnique(items), 'rank');

    return RankedBallot.protected(voter, items);
  }

  @override
  String toString() =>
      "{RankedBallot for '$voter', ranked ${rank.length} candidates}";
}
