import 'dart:collection';

class ElectionPlace<TCandidate extends Comparable>
    extends UnmodifiableListView<TCandidate> {
  final int place;

  ElectionPlace(this.place, Iterable<TCandidate> candidates)
      : assert(place > 0),
        assert(length > 0),
        super(candidates.toList()..sort());

  @override
  String toString() => 'Place: $place; ${super.toString()}';
}
