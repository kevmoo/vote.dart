import 'package:meta/meta.dart';

import 'ranked_ballot.dart';

@immutable
class CondorcetPair<TCandidate extends Comparable>
    implements Comparable<CondorcetPair> {
  final TCandidate candidate1, candidate2;

  final int? firstOverSecond;
  final int? secondOverFirst;

  /// Number of ballots where neither candidate was listed
  final int? ties;

  const CondorcetPair._internal(
    this.candidate1,
    this.candidate2,
    this.firstOverSecond,
    this.secondOverFirst,
    this.ties,
  );

  factory CondorcetPair(
    TCandidate can1,
    TCandidate can2, [
    List<RankedBallot<TCandidate>>? ballots,
  ]) {
    (can1, can2) = _sortPair(can1, can2);

    if (ballots == null) {
      return CondorcetPair._internal(can1, can2, null, null, null);
    }

    final (:firstOverSecond, :secondOverFirst, :ties) = _tallyBallots(
      can1,
      can2,
      ballots,
    );

    return CondorcetPair._internal(
      can1,
      can2,
      firstOverSecond,
      secondOverFirst,
      ties,
    );
  }

  TCandidate? get winner {
    if (firstOverSecond! > secondOverFirst!) {
      return candidate1;
    } else if (secondOverFirst! > firstOverSecond!) {
      return candidate2;
    } else {
      assert(isTie);
      return null;
    }
  }

  bool get isTie => firstOverSecond == secondOverFirst;

  bool matches(TCandidate can1, TCandidate can2) {
    final (sorted1, sorted2) = _sortPair(can1, can2);
    return candidate1 == sorted1 && candidate2 == sorted2;
  }

  // sometimes it's nice to deal w/ a properly aligned pair
  CondorcetPair<TCandidate> flip(TCandidate firstCandidate) {
    assert(firstCandidate == candidate1 || firstCandidate == candidate2);

    if (firstCandidate == candidate2) {
      return CondorcetPair._internal(
        candidate2,
        candidate1,
        secondOverFirst,
        firstOverSecond,
        ties,
      );
    }
    return this;
  }

  @override
  bool operator ==(Object other) =>
      other is CondorcetPair &&
      candidate1 == other.candidate1 &&
      candidate2 == other.candidate2;

  @override
  int get hashCode => Object.hash(candidate1, candidate2);

  @override
  String toString() => '($candidate1, $candidate2)';

  @override
  int compareTo(CondorcetPair<Comparable> other) {
    var value = candidate1.compareTo(other.candidate1);
    if (value == 0) {
      value = candidate2.compareTo(other.candidate2);
    }
    return value;
  }
}

/// Tallies head-to-head ballot preferences between [can1] and [can2],
/// returning counts for [can1] ranked over [can2], [can2] over [can1], and
/// ballots with neither.
({int firstOverSecond, int secondOverFirst, int ties}) _tallyBallots<
  TCandidate extends Comparable
>(TCandidate can1, TCandidate can2, List<RankedBallot<TCandidate>> ballots) {
  var firstOverSecond = 0;
  var secondOverFirst = 0;
  var ties = 0;
  for (final b in ballots) {
    final firstIndex = b.rank.indexOf(can1);
    final secondIndex = b.rank.indexOf(can2);

    switch ((firstIndex, secondIndex)) {
      case (< 0, < 0):
        ties++;
      case (< 0, _):
        secondOverFirst++;
      case (_, < 0):
        firstOverSecond++;
      case _ when firstIndex < secondIndex:
        firstOverSecond++;
      case _:
        secondOverFirst++;
    }
  }
  return (
    firstOverSecond: firstOverSecond,
    secondOverFirst: secondOverFirst,
    ties: ties,
  );
}

/// Normalizes a candidate pair such that the first candidate precedes the
/// second according to [Comparable.compareTo].
(TCandidate, TCandidate) _sortPair<TCandidate extends Comparable>(
  TCandidate can1,
  TCandidate can2,
) {
  assert(can1 != can2, 'can1 and can2 must be different');
  return can1.compareTo(can2) > 0 ? (can2, can1) : (can1, can2);
}
