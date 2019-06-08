import 'package:flutter_web_ui/ui.dart';

class Sim<T extends Comparable> implements Comparable<Sim<T>> {
  final T id;
  final Point location;

  const Sim(this.id, this.location);

  @override
  bool operator ==(other) => other is Sim && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  int compareTo(Sim<T> other) => id.compareTo(other.id);

  @override
  String toString() => 'Sim($id)';
}
