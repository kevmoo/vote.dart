import 'package:flutter/widgets.dart';
import 'package:vote/vote.dart';

import '../model/candidate.dart';
import '../model/election_data.dart';
import 'editor.dart';

class SimpleBallotEditor extends KnarlyEditor<ElectionData> {
  final textController = TextEditingController();

  SimpleBallotEditor({
    @required ElectionData electionData,
  }) : super(electionData) {
    textController
      ..text = _BallotLines.fromBallots(value.ballots).text
      ..addListener(_onTextChange);
  }

  void action() {
    textController.selection =
        TextSelection.collapsed(offset: textController.text.length);
  }

  @override
  bool updateSource(ElectionData data) {
    setValue(ElectionData.fromData(
      data.ballots,
      candidates: data.candidates,
    ));
    return true;
  }

  void _onTextChange() {
    print('TODO: text changed');
  }

  @override
  void dispose() {
    textController.removeListener(_onTextChange);
    super.dispose();
  }
}

class _BallotLines {
  final int countWidth;
  final int candidateWidth;
  final List<_BallotLine> lines;

  _BallotLines(this.countWidth, this.candidateWidth, this.lines);

  factory _BallotLines.fromBallots(Iterable<RankedBallot<Candidate>> ballots) {
    final candidates = <Candidate>{};

    final grouped = ballots.fold<Map<RankedBallot<Candidate>, int>>(
      <RankedBallot<Candidate>, int>{},
      (map, ballot) {
        candidates.addAll(ballot.rank);
        map[ballot] = (map[ballot] ?? 0) + 1;
        return map;
      },
    );

    final candidateWidth = candidates.fold<int>(0, (length, c) {
      if (c.id.length > length) {
        return c.id.length;
      }
      return length;
    });

    final countWidth = grouped.values.fold<int>(0, (length, value) {
      final str = value.toString().length;
      if (str > length) {
        return str;
      }
      return length;
    });

    final sortedBallots = grouped.entries.toList(growable: false)
      ..sort((a, b) {
        var value = b.value.compareTo(a.value);
        if (value == 0) {
          value = a.key.compareTo(b.key);
        }
        return value;
      });

    return _BallotLines(
        countWidth,
        candidateWidth,
        sortedBallots
            .map((e) => _BallotLine(e.value, e.key.rank))
            .toList(growable: false));
  }

  String get text => lines.map((b) {
        final candidates =
            b.candidates.map((c) => c.id.padLeft(candidateWidth)).join(' > ');
        return '${b.count.toString().padLeft(countWidth)} : $candidates';
      }).join('\n');
}

class _BallotLine {
  final int count;
  final List<Candidate> candidates;

  _BallotLine(this.count, this.candidates);
}
