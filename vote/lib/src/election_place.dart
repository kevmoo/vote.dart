import 'dart:collection';

import 'package:meta/meta.dart';

import 'util.dart';

@immutable
class ElectionPlace<TCandidate extends Comparable>
    extends UnmodifiableListView<TCandidate> {
  final int place;

  ElectionPlace(this.place, List<TCandidate> candidates)
      : assert(place > 0),
        assert(candidates.isNotEmpty),
        assert(sorted(candidates)),
        super(candidates);

  @override
  String toString() => 'Place: $place; ${super.toString()}';
}
