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
      : assert(rank.isNotEmpty),
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
  int get hashCode => Object.hashAll(rank);

  @override
  int compareTo(RankedBallot<TCandidate> other) =>
      compareRanks(rank, other.rank);

  static int compareRanks<T extends Comparable>(List<T> a, List<T> b) {
    int value;
    for (var i = 0; i < a.length; i++) {
      if (b.length <= i) {
        return 1;
      }
      value = a[i].compareTo(b[i]);
      if (value != 0) {
        return value;
      }
    }
    if (b.length > a.length) {
      return -1;
    }

    return 0;
  }
}
