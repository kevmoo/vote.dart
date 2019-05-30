import 'dart:collection';

import 'package:meta/meta.dart';

@immutable
class ElectionPlace<TCandidate extends Comparable>
    extends UnmodifiableListView<TCandidate> {
  final int place;

  ElectionPlace(this.place, Iterable<TCandidate> candidates)
      : assert(place > 0),
        assert(candidates.isNotEmpty),
        super(candidates.toList()..sort());

  @override
  String toString() => 'Place: $place; ${super.toString()}';
}
