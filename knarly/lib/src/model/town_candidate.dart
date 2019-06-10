import 'package:flutter_web_ui/ui.dart';

import 'sim.dart';

class TownCandidate implements Sim<String> {
  static const _capitalACharCode = 65;

  final int _value;

  @override
  final Point location;

  TownCandidate(this._value, this.location);

  @override
  String get id => String.fromCharCode(_value + _capitalACharCode);

  @override
  int compareTo(Sim<String> other) => id.compareTo(other.id);

  @override
  bool operator ==(other) => other is TownCandidate && _value == other._value;

  @override
  int get hashCode => _value.hashCode;
}
