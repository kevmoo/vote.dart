import 'package:flutter_web/foundation.dart';

import 'model/vote_town.dart';

class VoteTownNotifier extends ChangeNotifier
    implements ValueListenable<VoteTown> {
  /// Creates a [ChangeNotifier] that wraps this value.
  VoteTownNotifier(this._value);

  @override
  VoteTown get value => _value;
  VoteTown _value;
}
