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
    assert(can1 != can2, 'can1 and can2 must be different');

    if (can1.compareTo(can2) > 0) {
      final temp = can2;
      can2 = can1;
      can1 = temp;
    }

    if (ballots == null) {
      return CondorcetPair._internal(can1, can2, null, null, null);
    } else {
      var firstOverSecond = 0;
      var secondOverFirst = 0;
      var ties = 0;
      for (var b in ballots) {
        final firstIndex = b.rank.indexOf(can1);
        final secondIndex = b.rank.indexOf(can2);

        if (firstIndex < 0) {
          if (secondIndex < 0) {
            // neither candidate is in the ballot
            ties++;
          } else {
            secondOverFirst++;
          }
        } else if (secondIndex < 0) {
          firstOverSecond++;
        } else if (firstIndex < secondIndex) {
          firstOverSecond++;
        } else {
          secondOverFirst++;
        }
      }

      return CondorcetPair._internal(
        can1,
        can2,
        firstOverSecond,
        secondOverFirst,
        ties,
      );
    }
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
    assert(can1 != can2, 'can1 and can2 must be different');

    if (can1.compareTo(can2) > 0) {
      final temp = can2;
      can2 = can1;
      can1 = temp;
    }

    return (candidate1 == can1) && (candidate2 == can2);
  }

  // sometimes it's nice to deal w/ a properly aligned pair
  CondorcetPair<TCandidate> flip(TCandidate firstCandidate) {
    assert(firstCandidate == candidate1 || firstCandidate == candidate2);

    var can2 = firstCandidate == candidate1 ? candidate2 : candidate1;

    var flipped = false;
    if (firstCandidate.compareTo(can2) > 0) {
      final temp = can2;
      can2 = firstCandidate;
      firstCandidate = temp;
      flipped = true;
    }

    assert(firstCandidate == candidate1, 'can1');
    assert(can2 == candidate2, 'can2');

    if (flipped) {
      return CondorcetPair._internal(
        can2,
        firstCandidate,
        secondOverFirst,
        firstOverSecond,
        ties,
      );
    } else {
      return this;
    }
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
