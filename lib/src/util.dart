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

bool allUnique(Iterable items) {
  requireArgumentNotNull(items, 'items');

  for (int i = 0; i < items.length; i++) {
    for (int j = i + 1; j < items.length; j++) {
      if (items.elementAt(i) == items.elementAt(j)) {
        return false;
      }
    }
  }
  return true;
}

int _combine(int hash, Object o) {
  assert(o is! Iterable);
  hash = 0x1fffffff & (hash + o.hashCode);
  hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
  return hash ^ (hash >> 6);
}

int _finish(int hash) {
  hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
  hash = hash ^ (hash >> 11);
  return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
}

int hashValues(Object arg01, Object arg02) {
  int result = 0;
  result = _combine(result, arg01);
  result = _combine(result, arg02);

  return _finish(result);
}
