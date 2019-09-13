import 'package:flutter/widgets.dart';
import 'package:vote/vote.dart';

import '../model/candidate.dart';
import '../model/election_data.dart';
import 'editor.dart';

class SimpleBallotEditor extends KnarlyEditor<ElectionData> {
  final textController = TextEditingController();

  BallotLines<Candidate> _candidateLines;
  BallotLines<Candidate> _ballotLines;

  SimpleBallotEditor({
    @required ElectionData electionData,
  }) : super(electionData) {
    _updateBallots();
  }

  String validator(String input) {
    BallotLines<Candidate> parsedValue;
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
      ElectionData.fromData(_candidateLines.ballots.toList(growable: false)),
    );
  }

  bool get error => _candidateLines == null;

  bool get valueChanged => _ballotLines != _candidateLines;

  @override
  bool updateSource(ElectionData data) {
    setValue(ElectionData.fromData(
      data.ballots,
      candidates: data.candidates,
    ));
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
  var offset = 0;
  return Map.fromEntries(sorted.map(
    (e) {
      final hue = 360 * offset / values.length;
      offset++;
      return MapEntry(e, Candidate(e, hue));
    },
  ));
}
