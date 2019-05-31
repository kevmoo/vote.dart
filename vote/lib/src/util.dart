int majorityThreshold(int votes) {
  assert(votes > 0);
  return votes ~/ 2 + 1;
}

bool sorted(Iterable<Comparable> items) {
  Comparable last;
  for (var item in items) {
    if (item == null) {
      throw ArgumentError('null items are not supported.');
    }

    if (last != null && last.compareTo(item) > 0) {
      return false;
    }
    last = item;
  }

  return true;
}

bool allUnique(List items) {
  assert(items != null, 'items');

  for (var i = 0; i < items.length; i++) {
    for (var j = i + 1; j < items.length; j++) {
      if (items.elementAt(i) == items.elementAt(j)) {
        return false;
      }
    }
  }
  return true;
}
