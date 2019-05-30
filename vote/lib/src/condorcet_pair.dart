import 'package:meta/meta.dart';

import 'ranked_ballot.dart';
import 'util.dart';

@immutable
class CondorcetPair<TVoter, TCandidate extends Comparable> {
  final TCandidate candidate1, candidate2;
  final List<RankedBallot<TVoter, TCandidate>> ballots;
  final int firstOverSecond;
  final int secondOverFirst;

  const CondorcetPair._internal(
    this.candidate1,
    this.candidate2,
    this.ballots,
    this.firstOverSecond,
    this.secondOverFirst,
  );

  factory CondorcetPair(TCandidate can1, TCandidate can2,
      [List<RankedBallot<TVoter, TCandidate>> ballots]) {
    requireArgumentNotNull(can1, 'can1');
    requireArgumentNotNull(can2, 'can2');
    requireArgument(can1 != can2, 'can1 and can2 must be different');

    if (can1.compareTo(can2) > 0) {
      final temp = can2;
      can2 = can1;
      can1 = temp;
    }

    if (ballots == null) {
      return CondorcetPair._internal(can1, can2, null, 0, 0);
    } else {
      requireArgument(
          allUnique(ballots), 'Only one ballot per voter is allowed');

      var fos = 0;
      var sof = 0;
      for (var b in ballots) {
        final firstIndex = b.rank.indexOf(can1);
        requireArgument(firstIndex >= 0, 'bals');

        final secondIndex = b.rank.indexOf(can2);
        requireArgument(secondIndex >= 0, 'bals');

        assert(firstIndex != secondIndex);
        if (firstIndex < secondIndex) {
          fos++;
        } else {
          sof++;
        }
      }

      return CondorcetPair._internal(can1, can2, ballots, fos, sof);
    }
  }

  TCandidate get winner {
    if (firstOverSecond > secondOverFirst) {
      return candidate1;
    } else if (secondOverFirst > firstOverSecond) {
      return candidate2;
    } else {
      assert(isTie);
      return null;
    }
  }

  bool get isTie => firstOverSecond == secondOverFirst;

  bool matches(TCandidate can1, TCandidate can2) {
    requireArgumentNotNull(can1, 'can1');
    requireArgumentNotNull(can2, 'can2');
    requireArgument(can1 != can2, 'can1 and can2 must be different');

    if (can1.compareTo(can2) > 0) {
      final temp = can2;
      can2 = can1;
      can1 = temp;
    }

    return (candidate1 == can1) && (candidate2 == can2);
  }

  // sometimes it's nice to deal w/ a properly aligned pair
  CondorcetPair<TVoter, TCandidate> flip(TCandidate can1, TCandidate can2) {
    if (candidate1.compareTo(candidate2) > 0) {
      throw ArgumentError('already flipped!');
    }
    requireArgumentNotNull(can1, 'can1');
    requireArgumentNotNull(can2, 'can2');
    requireArgument(can1 != can2, 'can1 and can2 must be different');

    var flipped = false;
    if (can1.compareTo(can2) > 0) {
      final temp = can2;
      can2 = can1;
      can1 = temp;
      flipped = true;
    }

    requireArgument(can1 == candidate1, 'can1');
    requireArgument(can2 == candidate2, 'can1');

    if (flipped) {
      return CondorcetPair._internal(
          can2, can1, ballots, secondOverFirst, firstOverSecond);
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
  int get hashCode => candidate1.hashCode * 37 ^ candidate2.hashCode;
}
