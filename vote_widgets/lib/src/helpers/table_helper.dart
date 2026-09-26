import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vote/vote.dart';

import '../model/candidate.dart';

enum SubEntryPosition() {
  first,
  middle,
  last,
  single,
}

abstract class const TableHelper<Entry extends ElectionPlace<Candidate>>() {
  List<Entry> get places;

  List<Object> get columns;

  List<Candidate> subEntriesForEntry(Entry entry) => entry;

  Color subEntryColor(Candidate subEntry) => subEntry.color;

  bool isMulti(int columnIndex) => columnIndex == 1;

  TableColumnWidth get defaultTableColumnWidth => const FlexColumnWidth();

  String textForColumn(int columnIndex, Entry entry) => columnIndex == 0
      ? entry.place.toString()
      : throw ArgumentError(
          'Could not get a value for $columnIndex from $entry',
        );

  String textForSubEntry(int columnIndex, Candidate subEntry) =>
      columnIndex == 1
      ? subEntry.id
      : throw ArgumentError(
          'Could not get a value for $columnIndex from $subEntry',
        );

  Widget _tableHeader(int columnIndex) {
    final content = columns[columnIndex];

    final child = switch (content) {
      final String text => Text(text),
      final IconData icon => Icon(icon),
      _ => throw UnsupportedError('Cannot party on $content'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.5, horizontal: 3),
      child: child,
    );
  }

  static Widget _tableCell(
    String content, {
    Color? color,
    SubEntryPosition position = SubEntryPosition.single,
    required bool winner,
  }) => Container(
    color: color,
    // This is some very nuanced logic for making sure the sizes of rows
    // are consistent as they are merged and un-merged
    padding: EdgeInsets.fromLTRB(
      9,
      position == SubEntryPosition.first ? 8 : 9,
      9,
      position == SubEntryPosition.last ? 8 : 9,
    ),
    child: Text(content, style: winner ? winnerTextStyle : null),
  );

  Widget _widgetForSubEntry(
    int columnIndex,
    Candidate subEntry,
    SubEntryPosition position, {
    required bool winner,
  }) => _tableCell(
    textForSubEntry(columnIndex, subEntry),
    position: position,
    color: position == SubEntryPosition.single ? null : subEntryColor(subEntry),
    winner: winner,
  );

  Widget build(BuildContext context) => DefaultTextStyle(
    textAlign: TextAlign.center,
    style: DefaultTextStyle.of(context).style,
    child: Table(
      defaultColumnWidth: defaultTableColumnWidth,
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        TableRow(
          children: List.generate(
            columns.length,
            _tableHeader,
            growable: false,
          ),
        ),
        ...places.map((entry) {
          final subEntries = subEntriesForEntry(entry);
          return TableRow(
            decoration: BoxDecoration(
              color: subEntries.length == 1
                  ? subEntryColor(subEntries.single)
                  : null,
            ),
            children: List.generate(columns.length, (column) {
              if (isMulti(column)) {
                if (subEntries.length == 1) {
                  return _widgetForSubEntry(
                    column,
                    subEntries.single,
                    SubEntryPosition.single,
                    winner: entry.topPlace,
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: List.generate(subEntries.length, (
                        subEntryIndex,
                      ) {
                        final subEntry = subEntries[subEntryIndex];
                        return _widgetForSubEntry(
                          column,
                          subEntry,
                          _position(subEntries.length, subEntryIndex),
                          winner: entry.topPlace,
                        );
                      }),
                    ),
                  );
                }
              } else {
                return _tableCell(
                  textForColumn(column, entry),
                  winner: entry.topPlace,
                );
              }
            }, growable: false),
          );
        }),
      ],
    ),
  );
}

const winnerTextStyle = TextStyle(
  fontWeight: FontWeight.w800,
  decoration: TextDecoration.underline,
  decorationThickness: 0.0,
);

SubEntryPosition _position(int length, int index) {
  assert(length > 0);
  assert(index >= 0 && index < length);
  if (length == 1) {
    assert(index == 0);
    return SubEntryPosition.single;
  }

  if (index == 0) {
    return SubEntryPosition.first;
  }

  if (index == length - 1) {
    return SubEntryPosition.last;
  }

  return SubEntryPosition.middle;
}
