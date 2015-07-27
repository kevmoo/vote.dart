library vote.vote.election_place;

import 'dart:collection';
import 'player.dart';

class ElectionPlace<TCandidate extends Player>
    extends UnmodifiableListView<TCandidate> {
  final int place;

  ElectionPlace(this.place, Iterable<TCandidate> candidates)
      : super(candidates) {
    assert(place > 0);
    assert(length > 0);
  }

  String toString() => "Place: $place; ${super.toString()}";
}
