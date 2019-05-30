void requireArgument(bool truth, String argName, [String message]) {
  if (!truth) {
    if (message == null || message.isEmpty) {
      message = 'value was invalid';
    }
    throw ArgumentError([argName, message]);
  }
}

void requireArgumentNotNull(argument, String argName) {
  if (argument == null) {
    throw ArgumentError.notNull(argName);
  }
}

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

bool allUnique(Iterable items) {
  requireArgumentNotNull(items, 'items');

  for (var i = 0; i < items.length; i++) {
    for (var j = i + 1; j < items.length; j++) {
      if (items.elementAt(i) == items.elementAt(j)) {
        return false;
      }
    }
  }
  return true;
}
