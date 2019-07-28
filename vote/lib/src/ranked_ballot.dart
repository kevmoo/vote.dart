import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import 'plurality_ballot.dart';
import 'util.dart';

@immutable
class RankedBallot<TCandidate extends Comparable>
    implements
        PluralityBallot<TCandidate>,
        Comparable<RankedBallot<TCandidate>> {
  @override
  TCandidate get choice => rank.first;

  final List<TCandidate> rank;

  RankedBallot(this.rank)
      : assert(rank != null),
        assert(rank.isNotEmpty),
        assert(allUnique(rank));

  @override
  Iterable<TCandidate> referencedCandidates() => rank;

  @override
  String toString() => '{RankedBallot for ${rank.length} candidates}';

  @override
  bool operator ==(Object other) =>
      other is RankedBallot<TCandidate> &&
      const ListEquality().equals(other.rank, rank);

  @override
  int get hashCode => const ListEquality().hash(rank);

  @override
  int compareTo(RankedBallot<TCandidate> other) {
    int value;
    for (var i = 0; i < rank.length; i++) {
      if (other.rank.length <= i) {
        return 1;
      }
      value = rank[i].compareTo(other.rank[i]);
      if (value != 0) {
        return value;
      }
    }
    if (other.rank.length > rank.length) {
      return -1;
    }

    return 0;
  }
}
