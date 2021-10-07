import 'dart:collection';

import 'package:meta/meta.dart';

@immutable

/// The resulting place a candidate received in an election.
class ElectionPlace<TCandidate extends Comparable>
    extends UnmodifiableListView<TCandidate> {
  final int place;

  ElectionPlace(this.place, List<TCandidate> candidates)
      : assert(place > 0),
        assert(candidates.isNotEmpty),
        super(candidates);

  bool get topPlace => place == 1;

  @override
  String toString() => 'Place: $place; ${super.toString()}';
}
