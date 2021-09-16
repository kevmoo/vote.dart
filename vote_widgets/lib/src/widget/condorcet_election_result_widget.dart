import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vote/vote.dart';

import '../helpers/helpers.dart';
import 'table_pane.dart' as tp;
import 'utility_widgets.dart';

class CondorcetElectionResultWidget<TCandidate extends Comparable<TCandidate>>
    extends StatefulWidget {
  final CondorcetElectionResult<TCandidate> _election;

  const CondorcetElectionResultWidget(this._election);

  @override
  State<StatefulWidget> createState() => _State<TCandidate>();
}

enum CondorcetWidgetDisplay {
  comparison,
  simple,
  delta,
}

class _State<TCandidate extends Comparable<TCandidate>>
    extends State<CondorcetElectionResultWidget<TCandidate>> {
  CondorcetWidgetDisplay _display = CondorcetWidgetDisplay.simple;

  @override
  Widget build(BuildContext context) => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: _onTap,
          child: tp.TablePane(
            columns: [
              const tp.TablePaneColumn(
                  width: tp.IntrinsicTablePaneColumnWidth()),
              const tp.TablePaneColumn(
                  width: tp.IntrinsicTablePaneColumnWidth()),
              ...List.generate(
                _election.candidates.length,
                (index) => const tp.TablePaneColumn(),
              )
            ],
            children: [
              tp.TableRow(
                backgroundColor: Theme.of(context).backgroundColor,
                children: [
                  const PaddedText(text: 'Place'),
                  const PaddedText(text: candidateString),
                  ...List.generate(
                    _election.candidates.length,
                    (index) => PaddedText(
                      text: _election.candidates[index].toString(),
                    ),
                  )
                ],
              ),
              ..._rows(),
            ],
          ),
        ),
      );

  Iterable<tp.TableRow> _rows() sync* {
    for (var place in _election.places) {
      var first = true;
      for (var candidate in place) {
        final background = _candidateColors[candidate];
        yield tp.TableRow(
          backgroundColor: place.length == 1 ? background : null,
          children: [
            if (first)
              tp.TableCell(
                rowSpan: place.length,
                child: Center(child: PaddedText(text: place.place.toString())),
              ),
            if (!first) const tp.EmptyTableCell(),
            PaddedText(text: candidate.toString(), background: background),
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

                return _getCellText(pair, background);
              },
            )
          ],
        );
        first = false;
      }
    }
  }

  void _onTap() {
    final next = CondorcetWidgetDisplay.values[
        (CondorcetWidgetDisplay.values.indexOf(_display) + 1) %
            CondorcetWidgetDisplay.values.length];
    setState(() {
      _display = next;
    });
  }

  Widget _getCellText(CondorcetPair<TCandidate> pair, Color? background) {
    switch (_display) {
      case CondorcetWidgetDisplay.comparison:
        return _comparisonText(pair);
      case CondorcetWidgetDisplay.delta:
        return PaddedText(
          text: pair.delta,
          background: background,
        );
      case CondorcetWidgetDisplay.simple:
        if (pair.firstWins) {
          return CelPadding(
            background: background,
            child: const Icon(
              Icons.check,
              size: 16,
            ),
          );
        }
        if (pair.isTie) {
          return PaddedText(
            text: '=',
            style: pair.style,
            background: background,
          );
        }
        return CelPadding(
          background: background,
          child: const Icon(
            Icons.cancel_outlined,
            size: 16,
            color: _lostDimColor,
          ),
        );
    }
  }

  Widget _comparisonText(CondorcetPair<TCandidate> pair) {
    final primaryCandidate = pair.candidate1;

    final comparison = pair.isTie
        ? '='
        : pair.winner == primaryCandidate
            ? '>'
            : '<';

    final background = _candidateColors[primaryCandidate];
    return PaddedText(
      text: '${pair.firstOverSecond}$comparison${pair.secondOverFirst}',
      style: pair.style,
      background: background,
    );
  }

  late final Map<TCandidate, Color> _candidateColors =
      huesForCandidates(_election.candidates);

  CondorcetElectionResult<TCandidate> get _election => widget._election;
}

extension on CondorcetPair {
  String get delta {
    final value = (firstOverSecond ?? 0) - (secondOverFirst ?? 0);

    if (value > 0) {
      return '+$value';
    }
    return value.toString();
  }

  bool get firstWins => winner == candidate1;

  Color get color => firstWins
      ? Colors.black
      : isTie
          ? _tieColor
          : _lostDimColor;

  TextStyle get style => TextStyle(color: color);
}

const _lostDimColor = Colors.black38;
const _tieColor = Colors.black54;
