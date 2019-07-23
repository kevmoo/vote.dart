import 'package:flutter_web/material.dart' show ChangeNotifier, ValueListenable;
import 'package:meta/meta.dart' show protected;

import '../model/election_data.dart';

abstract class KnarlyEditor<T extends ElectionData> extends ChangeNotifier
    implements ValueListenable<T> {
  @override
  T get value => _value;
  T _value;

  @protected
  void setValue(T value) {
    assert(value != null);
    if (value != _value) {
      _value = value;
      notifyListeners();
    }
  }

  KnarlyEditor(this._value);

  bool updateSource(ElectionData data) => false;
}
