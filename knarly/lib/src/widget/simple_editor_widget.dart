import 'package:flutter_web/material.dart';
import 'package:flutter_web/widgets.dart';
import 'package:provider/provider.dart';
import 'package:vote/vote.dart';

import '../model/candidate.dart';
import '../view_model/simple_ballot_editor.dart';

class SimpleEditorWidget extends StatelessWidget {
  const SimpleEditorWidget();

  @override
  Widget build(BuildContext context) => Consumer<SimpleBallotEditor>(
        builder: (_, editor, __) => Container(
          width: 500,
          height: 500,
          padding: const EdgeInsets.all(10),
          color: Colors.grey.shade100,
          child: Text(
            _ballotText(editor.value.ballots),
            softWrap: false,
            style: const TextStyle(
              fontFamily: 'monospace',
            ),
          ),
        ),
      );
}

String _ballotText(Iterable<RankedBallot<Candidate>> ballots) {
  final map = <String, int>{};
  for (var ballot in ballots) {
    final str = ballot.rank.map((c) => c.id).join(' > ');
    map[str] = (map[str] ?? 0) + 1;
  }

  final list = map.entries.toList(growable: false)
    ..sort((a, b) {
      var value = b.value.compareTo(a.value);
      if (value == 0) {
        value = a.key.compareTo(b.key);
      }
      return value;
    });

  return list.map((e) => '${e.value} : ${e.key}').join('\n');
}
