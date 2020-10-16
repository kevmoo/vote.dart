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

/// Asserts that all [items] are not `null`.
bool allUnique(List items) {
  for (var i = 0; i < items.length; i++) {
    final value = items[i];
    assert(value != null);
    for (var j = i + 1; j < items.length; j++) {
      if (value == items[j]) {
        return false;
      }
    }
  }
  return true;
}
