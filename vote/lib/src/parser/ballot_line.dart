import 'package:collection/collection.dart';

import '../ranked_ballot.dart' show RankedBallot;
import '../util.dart';

class BallotLine<TCandidate extends Comparable<dynamic>>(
  final int count,
  final List<TCandidate> candidates,
) implements Comparable<BallotLine<Comparable<dynamic>>> {
  this : assert(count > 0), assert(candidates.allUnique);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is BallotLine &&
        other.count == count &&
        const ListEquality<Object>().equals(other.candidates, candidates);
  }

  @override
  int get hashCode => Object.hash(count, Object.hashAll(candidates));

  @override
  int compareTo(BallotLine<Comparable<dynamic>> other) {
    var value = other.count.compareTo(count);
    if (value == 0) {
      value = RankedBallot.compareRanks(candidates, other.candidates);
    }
    return value;
  }

  @override
  String toString() => '$count : ${candidates.join(' > ')}';
}
