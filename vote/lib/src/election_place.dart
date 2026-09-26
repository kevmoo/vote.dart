import 'dart:collection';

import 'package:meta/meta.dart';

@immutable
/// The resulting place a candidate received in an election.
class ElectionPlace<TCandidate extends Comparable<Object>>(
  final int place,
  List<TCandidate> super.candidates,
) extends UnmodifiableListView<TCandidate> {
  this : assert(place > 0), assert(candidates.isNotEmpty);

  bool get topPlace => place == 1;

  @override
  String toString() => 'Place: $place; ${super.toString()}';
}
