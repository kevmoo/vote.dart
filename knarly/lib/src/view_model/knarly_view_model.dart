import 'package:flutter_web/widgets.dart' show ChangeNotifier;
import 'package:knarly/src/view_model/editor.dart';

import '../model/election_data.dart';

class KnarlyViewModel extends ChangeNotifier {
  ElectionData _electionData;
  KnarlyEditor _editor;

  KnarlyViewModel(KnarlyEditor editor) {
    _setEditor(editor);
  }

  ElectionData get electionData {
    assert(_editor != null);
    assert(_editor.value != null);
    return _editor.value;
  }

  KnarlyEditor get editor => _editor;

  void _setEditor(KnarlyEditor value) {
    assert(value != null);
    if (_editor == value) {
      return;
    }
    if (_editor != null) {
      _editor.removeListener(_editorValueUpdated);
    }
    _editor = value;
    if (_editor != null) {
      _editor.addListener(_editorValueUpdated);
    }
    notifyListeners();
  }

  void _editorValueUpdated() {
    if (_editor.value == _electionData) {
      return;
    }
    _electionData = _editor.value;
    notifyListeners();
  }
}
