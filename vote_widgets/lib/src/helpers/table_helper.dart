import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum SubEntryPosition {
  first,
  middle,
  last,
  single,
}

abstract class TableHelper<Entry, SubEntry> {
  const TableHelper();

  List<Entry> get places;

  List<String> get columns;

  List<SubEntry> subEntriesForEntry(Entry entry);

  Color subEntryColor(SubEntry subEntry);

  bool isMulti(int columnIndex);

  double get fontSizeFactor => 1.0;

  double get headerTextScaleFactor => 1.0;

  TableColumnWidth get defaultTableColumnWidth => const FlexColumnWidth();

  String textForColumn(int columnIndex, Entry entry) =>
      throw ArgumentError('Could not get a value for $columnIndex from $entry');

  String textForSubEntry(int columnIndex, SubEntry subEntry) =>
      throw ArgumentError(
          'Could not get a value for $columnIndex from $subEntry');

  Widget _tableHeader(int columnIndex) => Container(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 3),
        child: Text(
          columns[columnIndex],
          textScaleFactor: headerTextScaleFactor,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );

  static Widget _tableCell(
    String content, {
    Color? color,
    SubEntryPosition position = SubEntryPosition.single,
  }) =>
      Container(
        color: color,
        // This is some very nuanced logic for making sure the sizes of rows
        // are consistent as they are merged and un-merged
        padding: EdgeInsets.fromLTRB(
          3,
          position == SubEntryPosition.first ? 2 : 3,
          3,
          position == SubEntryPosition.last ? 2 : 3,
        ),
        child: Text(content),
      );

  Widget widgetForSubEntry(
    int columnIndex,
    SubEntry subEntry,
    SubEntryPosition position,
  ) =>
      _tableCell(
        textForSubEntry(columnIndex, subEntry),
        position: position,
        color: position == SubEntryPosition.single
            ? null
            : subEntryColor(subEntry),
      );

  Widget build(BuildContext context) => DefaultTextStyle(
        textAlign: TextAlign.center,
        style: DefaultTextStyle.of(context).style.apply(
              fontSizeFactor: fontSizeFactor,
            ),
        child: Table(
          defaultColumnWidth: defaultTableColumnWidth,
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: <TableRow>[
            TableRow(
              decoration: BoxDecoration(color: Colors.grey.shade300),
              children:
                  List.generate(columns.length, _tableHeader, growable: false),
            ),
            ...places.map(
              (entry) {
                final subEntries = subEntriesForEntry(entry);
                return TableRow(
                  decoration: BoxDecoration(
                    color: subEntries.length == 1
                        ? subEntryColor(subEntries.single)
                        : null,
                    border: Border.all(),
                  ),
                  children: List.generate(columns.length, (column) {
                    if (isMulti(column)) {
                      if (subEntries.length == 1) {
                        return widgetForSubEntry(
                          column,
                          subEntries.single,
                          SubEntryPosition.single,
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 1,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: List.generate(
                              subEntries.length,
                              (subEntryIndex) {
                                final subEntry = subEntries[subEntryIndex];
                                return widgetForSubEntry(
                                  column,
                                  subEntry,
                                  _position(subEntries.length, subEntryIndex),
                                );
                              },
                            ),
                          ),
                        );
                      }
                    } else {
                      return _tableCell(textForColumn(column, entry));
                    }
                  }, growable: false),
                );
              },
            )
          ],
        ),
      );
}

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
