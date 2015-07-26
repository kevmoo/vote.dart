library vote.vote.ranked_ballot;

import 'package:bot/bot.dart' hide ReadOnlyCollection;

import '../util.dart';
import 'player.dart';
import 'plurality_ballot.dart';

class RankedBallot<TVoter extends Player, TCandidate extends Player>
    extends PluralityBallot<TVoter, TCandidate> {
  final ReadOnlyCollection<TCandidate> rank;

  RankedBallot.protected(TVoter voter, ReadOnlyCollection<TCandidate> items)
      : super(voter, items[0]),
        rank = items;

  factory RankedBallot(TVoter voter, Iterable<TCandidate> rank) {
    requireArgumentNotNull(voter, 'voter');
    requireArgumentNotNull(rank, 'rank');

    var items = new ReadOnlyCollection(rank);
    requireArgument(items.length > 0, 'rank');
    requireArgument(CollectionUtil.allUnique(items), 'rank');

    return new RankedBallot.protected(voter, items);
  }

  String toString() =>
      "{RankedBallot for '$voter', ranked ${rank.length} candidates}";
}
