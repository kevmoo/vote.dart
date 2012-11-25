part of vote;

class CondorcetPair<TVoter extends Player, TCandidate extends Player>
  extends Tuple<TCandidate, TCandidate>
  implements Hashable {

  final ReadOnlyCollection<RankedBallot<TVoter, TCandidate>> ballots;
  final int firstOverSecond;
  final int secondOverFirst;

  CondorcetPair._internal(TCandidate can1, TCandidate can2,
    this.ballots, this.firstOverSecond, this.secondOverFirst) :
    super(can1, can2);

  factory CondorcetPair(TCandidate can1, TCandidate can2,
    [Collection<RankedBallot<TVoter, TCandidate>> bals = null]) {
    requireArgumentNotNull(can1, 'can1');
    requireArgumentNotNull(can2, 'can2');
    requireArgument(can1 != can2, 'can1 and can2 must be different');

    if(can1.compareTo(can2) > 0) {
      var temp = can2;
      can2 = can1;
      can1 = temp;
    }

    if(bals == null) {
      return new CondorcetPair._internal(can1, can2, null, 0, 0);
    }
    else {
      var roBallots = new ReadOnlyCollection<RankedBallot<TVoter, TCandidate>>(bals);

      requireArgument(CollectionUtil.allUnique(roBallots),
        "Only one ballot per voter is allowed");

      int fos = 0;
      int sof = 0;
      roBallots.forEach((b) {
        final firstIndex = b.rank.indexOf(can1);
        requireArgument(firstIndex >= 0, 'bals');

        final secondIndex = b.rank.indexOf(can2);
        requireArgument(secondIndex >= 0, 'bals');

        assert(firstIndex != secondIndex);
        if(firstIndex < secondIndex) {
          fos++;
        }
        else {
          sof++;
        }
      });

      return new CondorcetPair._internal(can1, can2, roBallots, fos, sof);
    }

  }

  TCandidate get winner {
    if(firstOverSecond > secondOverFirst) {
      return item1;
    }
    else if(secondOverFirst > firstOverSecond) {
      return item2;
    }
    else {
      assert(isTie);
      return null;
    }
  }

  bool get isTie => firstOverSecond == secondOverFirst;

  bool matches(TCandidate can1, TCandidate can2) {
    requireArgumentNotNull(can1, 'can1');
    requireArgumentNotNull(can2, 'can2');
    requireArgument(can1 != can2, 'can1 and can2 must be different');

    if(can1.compareTo(can2) > 0) {
      var temp = can2;
      can2 = can1;
      can1 = temp;
    }

    return (item1 == can1) && (item2 == can2);
  }

  // sometimes it's nice to deal w/ a properly aligned pair
  CondorcetPair<TVoter, TCandidate> flip(TCandidate can1, TCandidate can2) {
    if(item1.compareTo(item2) > 0) {
      throw 'already flipped!';
    }
    requireArgumentNotNull(can1, 'can1');
    requireArgumentNotNull(can2, 'can2');
    requireArgument(can1 != can2, 'can1 and can2 must be different');

    bool flipped = false;
    if(can1.compareTo(can2) > 0) {
      var temp = can2;
      can2 = can1;
      can1 = temp;
      flipped = true;
    }

    requireArgument(can1 == item1, 'can1');
    requireArgument(can2 == item2, 'can1');

    if(flipped) {
      return new CondorcetPair._internal(can2, can1, ballots,
        secondOverFirst, firstOverSecond);
    } else {
      return this;
    }
  }

}
