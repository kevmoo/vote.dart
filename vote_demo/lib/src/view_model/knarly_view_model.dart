// undead:ignore_for_file
import 'package:flutter/widgets.dart' show ChangeNotifier;
import 'package:vote_simulation/vote_simulation.dart';

class KnarlyViewModel(Iterable<KnarlyEditor> editors) extends ChangeNotifier {
  final List<KnarlyEditor> _editors = editors.toList(growable: false);

  int _currentEditorIndex = 0;
  ElectionData? _electionData;

  this {
    assert(_editors.isNotEmpty);
    _editor.addListener(_editorValueUpdated);
  }

  KnarlyEditor get _editor => _editors[_currentEditorIndex];

  ElectionData get electionData => _editor.value;

  KnarlyEditor get editor => _editor;

  void Function()? get toggleFunction {
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
        print('Transferring data not supported');
      }
    } catch (e) {
      print('There was an error transferring data – hopefully nothing broke!');
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
