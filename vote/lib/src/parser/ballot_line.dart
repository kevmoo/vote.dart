import 'package:collection/collection.dart';

import '../ranked_ballot.dart' show RankedBallot;
import '../util.dart';

class BallotLine<TCandidate extends Comparable>
    implements Comparable<BallotLine> {
  final int count;
  final List<TCandidate> candidates;

  BallotLine(this.count, this.candidates)
      : assert(count > 0),
        assert(allUnique(candidates));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is BallotLine &&
        other.count == count &&
        const ListEquality().equals(other.candidates, candidates);
  }

  @override
  int get hashCode => Object.hash(count, Object.hashAll(candidates));

  @override
  int compareTo(BallotLine<Comparable> other) {
    var value = other.count.compareTo(count);
    if (value == 0) {
      value = RankedBallot.compareRanks(candidates, other.candidates);
    }
    return value;
  }

  @override
  String toString() => '$count : ${candidates.join(' > ')}';
}
