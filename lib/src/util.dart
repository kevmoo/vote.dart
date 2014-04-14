library vote.util;

import 'dart:collection';

class ReadOnlyCollection<T> extends UnmodifiableListView<T> {
  ReadOnlyCollection(Iterable<T> source)
      : super(source.toList(growable: false));

  ReadOnlyCollection.wrap(Iterable<T> source)
      : super(source);

  ReadOnlyCollection.empty()
      : super(const []);
}
