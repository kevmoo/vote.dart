import 'package:flutter/widgets.dart';
import 'package:vote/vote.dart';
import 'package:vote_widgets/vote_widgets.dart';

import '../model/election_data.dart';
import 'editor.dart';

class SimpleBallotEditor extends KnarlyEditor<ElectionData> {
  final textController = TextEditingController();

  BallotLines<Candidate>? _candidateLines;
  late BallotLines<Candidate> _ballotLines;

  SimpleBallotEditor({
    required ElectionData electionData,
  }) : super(electionData) {
    _updateBallots();
  }

  String? validator(String? input) {
    if (input == null) {
      return 'Cannot be null';
    }
    BallotLines<Candidate>? parsedValue;
    try {
      parsedValue = BallotLines<Candidate>.parse(
        input,
        _fromStrings,
        candidateToText: (c) => c.id,
      );
    } catch (e) {
      return e.toString();
    } finally {
      if (parsedValue != _candidateLines) {
        Future.microtask(() {
          _candidateLines = parsedValue;
          notifyListeners();
        });
      }
    }
    return null;
  }

  void commitChange() {
    assert(_candidateLines != null);
    assert(_ballotLines != _candidateLines);
    updateSource(
      ElectionData.fromData(_candidateLines!.ballots.toList(growable: false)),
    );
  }

  bool get error => _candidateLines == null;

  bool get valueChanged => _ballotLines != _candidateLines;

  @override
  bool updateSource(ElectionData data) {
    setValue(
      ElectionData.fromData(
        data.ballots,
        candidates: data.candidates,
      ),
    );
    return true;
  }

  @override
  bool setValue(ElectionData value) {
    if (super.setValue(value)) {
      _updateBallots();
      return true;
    }
    return false;
  }

  void _updateBallots() {
    _candidateLines = _ballotLines = BallotLines<Candidate>.fromBallots(
      value.ballots,
      candidateToText: (c) => c.id,
    );
    textController.text = _ballotLines.text;
  }
}

Map<String, Candidate> _fromStrings(Set<String> values) {
  final sorted = values.toList(growable: false)..sort();
  final delta = 360 / values.length;
  var offset = 0;
  return Map.fromEntries(
    sorted.map(
      (e) => MapEntry(e, Candidate(e, offset++ * delta)),
    ),
  );
}
