class CondorcetPair<TCandidate extends Player>
  extends Tuple<TCandidate, TCandidate>
  implements Hashable {

  CondorcetPair._internal(TCandidate can1, TCandidate can2) :
    super(can1, can2);

  factory CondorcetPair(TCandidate can1, TCandidate can2) {
    requireArgumentNotNull(can1, 'can1');
    requireArgumentNotNull(can2, 'can2');
    requireArgument(can1 != can2, 'can1 and can2 cannot be null');

    if(can1.compareTo(can2) > 0) {
      var temp = can2;
      can2 = can1;
      can1 = temp;
    }

    return new CondorcetPair._internal(can1, can2);
  }

  int hashCode() => Util.getHashCode([Item1, Item2]);
}
