import 'package:listen/listen.dart';
import 'package:meta/meta.dart';

import 'election_data.dart';

abstract class KnarlyEditor<T extends ElectionData>(var T _value)
    extends ChangeNotifier
    implements ValueListenable<T> {
  @override
  T get value => _value;
  @protected
  bool setValue(T value) {
    if (value != _value) {
      _value = value;
      notifyListeners();
      return true;
    }
    return false;
  }

  bool updateSource(ElectionData data) => false;
}
