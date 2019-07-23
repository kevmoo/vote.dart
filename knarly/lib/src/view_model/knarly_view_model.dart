import 'package:flutter_web/widgets.dart' show ChangeNotifier;
import 'package:knarly/src/view_model/editor.dart';

import '../model/election_data.dart';

class KnarlyViewModel extends ChangeNotifier {
  final List<KnarlyEditor> _editors;

  int _currentEditorIndex = 0;
  ElectionData _electionData;

  KnarlyViewModel(Iterable<KnarlyEditor> editors)
      : _editors = editors.toList(growable: false) {
    assert(_editors.isNotEmpty);
    _editor.addListener(_editorValueUpdated);
  }

  KnarlyEditor get _editor => _editors[_currentEditorIndex];

  ElectionData get electionData {
    assert(_editor != null);
    assert(_editor.value != null);
    return _editor.value;
  }

  KnarlyEditor get editor => _editor;

  void Function() get toggleFunction {
    if (_editors.length == 1) {
      return null;
    }
    return toggleEditor;
  }

  void toggleEditor() =>
      _setEditor((_currentEditorIndex + 1) % _editors.length);

  void _setEditor(int index) {
    RangeError.checkValidIndex(index, _editors);
    if (_currentEditorIndex == index) {
      return;
    }
    _editor.removeListener(_editorValueUpdated);
    final previousValue = _editor.value;
    _currentEditorIndex = index;
    _editor.addListener(_editorValueUpdated);

    try {
      if (_editor.updateSource(previousValue)) {
        print('Transferred data to editor successfully!');
      } else {
        print('Transfering data not supported');
      }
    } catch (e) {
      print('There was an error transfering data – hopefully nothing broke!');
      print(e);
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
