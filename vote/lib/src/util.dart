int majorityThreshold(int votes) {
  assert(votes > 0);
  return votes ~/ 2 + 1;
}

bool sorted(Iterable<Comparable> items) {
  Comparable? last;
  for (var item in items) {
    if (last != null && last.compareTo(item) > 0) {
      return false;
    }
    last = item;
  }

  return true;
}

extension ListExt<T> on List<T> {
  bool get allUnique {
    final seen = <T>{};
    for (var item in this) {
      assert(item != null);
      if (!seen.add(item)) return false;
    }
    return true;
  }
}
