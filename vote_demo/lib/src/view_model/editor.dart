import 'package:flutter/foundation.dart';

import '../model/election_data.dart';

abstract class KnarlyEditor<T extends ElectionData> extends ChangeNotifier
    implements ValueListenable<T> {
  @override
  T get value => _value;
  T _value;

  @protected
  bool setValue(T value) {
    if (value != _value) {
      _value = value;
      notifyListeners();
      return true;
    }
    return false;
  }

  KnarlyEditor(this._value);

  bool updateSource(ElectionData data) => false;
}
