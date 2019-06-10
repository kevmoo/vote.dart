import 'package:flutter_web_ui/ui.dart';

class TownVoter implements Comparable<TownVoter> {
  final int id;

  Color get color => null;

  final Point location;

  TownVoter(this.id, this.location) : assert(id >= 0);

  @override
  int compareTo(TownVoter other) => id.compareTo(other.id);

  @override
  bool operator ==(other) => other is TownVoter && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
