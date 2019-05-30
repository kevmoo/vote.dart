import 'dart:collection';

class ElectionPlace<TCandidate> extends UnmodifiableListView<TCandidate> {
  final int place;

  ElectionPlace(this.place, Iterable<TCandidate> candidates)
      : super(candidates) {
    assert(place > 0);
    assert(length > 0);
  }

  @override
  String toString() => "Place: $place; ${super.toString()}";
}
