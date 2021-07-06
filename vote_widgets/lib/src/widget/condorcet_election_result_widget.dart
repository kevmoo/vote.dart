import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vote/vote.dart';

import '../helpers/helpers.dart';
import '../model/candidate.dart';
import 'table_pane.dart' as tp;

class CondorcetElectionResultWidget<TCandidate extends Comparable<TCandidate>>
    extends StatelessWidget {
  final CondorcetElectionResult<TCandidate> condorcetElectionResult;

  const CondorcetElectionResultWidget(this.condorcetElectionResult);

  @override
  Widget build(BuildContext context) => _CondorcetTableHelper<TCandidate>(
        condorcetElectionResult,
      ).build(context);
}

class _CondorcetTableHelper<TCandidate extends Comparable<TCandidate>> {
  final CondorcetElectionResult<TCandidate> _election;

  late final Map<TCandidate, Color> _candidateColors =
      huesForCandidates(_election.candidates);

  _CondorcetTableHelper(this._election);

  static Widget _paddedText(
    String text, {
    TextStyle? style,
    Color? background,
  }) =>
      Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        alignment: Alignment.center,
        color: background,
        child: Text(
          text,
          style: style,
          textAlign: TextAlign.center,
        ),
      );

  Widget build(BuildContext context) {
    Iterable<tp.TableRow> rows() sync* {
      for (var place in _election.places) {
        var first = true;
        for (var candidate in place) {
          final background = _colorForCandidate(candidate);
          yield tp.TableRow(
            backgroundColor: place.length == 1 ? background : null,
            children: [
              if (first)
                tp.TableCell(
                  rowSpan: place.length,
                  child: Center(child: _paddedText(place.place.toString())),
                ),
              if (!first) const tp.EmptyTableCell(),
              _paddedText(_idForCandidate(candidate), background: background),
              ...List.generate(
                _election.candidates.length,
                (index) {
                  final other = _election.candidates[index];
                  if (candidate == other) {
                    return Container(
                      color: background,
                    );
                  }

                  final pair =
                      _election.getPair(candidate, _election.candidates[index]);

                  TextStyle? style;

                  if (pair.isTie) {
                    style = const TextStyle(fontStyle: FontStyle.italic);
                  } else if (pair.winner == candidate) {
                    style = const TextStyle(fontWeight: FontWeight.bold);
                  }

                  final comparison = pair.isTie
                      ? '='
                      : pair.winner == pair.candidate1
                          ? '>'
                          : '<';

                  return _paddedText(
                    '${pair.firstOverSecond}$comparison${pair.secondOverFirst}',
                    style: style,
                    background: background,
                  );
                },
              )
            ],
          );
          first = false;
        }
      }
    }

    return DefaultTextStyle(
      textAlign: TextAlign.center,
      style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.4),
      child: tp.TablePane(
        columns: [
          const tp.TablePaneColumn(width: tp.IntrinsicTablePaneColumnWidth()),
          const tp.TablePaneColumn(width: tp.IntrinsicTablePaneColumnWidth()),
          ...List.generate(
            _election.candidates.length,
            (index) => const tp.TablePaneColumn(),
          )
        ],
        children: [
          DefaultTextStyle(
            style: DefaultTextStyle.of(context).style.apply(
                  fontSizeFactor: 1.4,
                  fontWeightDelta: 3,
                ),
            child: tp.TableRow(
              backgroundColor: Colors.grey.shade300,
              children: [
                _paddedText(
                  'Place',
                ),
                _paddedText(
                  Candidate.candidateString,
                ),
                ...List.generate(
                  _election.candidates.length,
                  (index) => _paddedText(
                    _idForCandidate(_election.candidates[index]),
                  ),
                )
              ],
            ),
          ),
          ...rows(),
        ],
      ),
    );
  }

  String _idForCandidate(Object candidate) {
    if (candidate is Candidate) {
      return candidate.id;
    }
    return candidate.toString();
  }

  Color _colorForCandidate(TCandidate candidate) =>
      _candidateColors[candidate]!;
}
