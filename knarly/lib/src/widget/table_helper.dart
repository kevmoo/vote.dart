import 'package:flutter_web/material.dart';

abstract class TableHelper<Entry, SubEntry> {
  const TableHelper();

  List<Entry> get places;

  List<String> get columns;

  List<SubEntry> subEntriesForEntry(Entry entry);

  Color subEntryColor(SubEntry subEntry);

  bool isMulti(int columnIndex);

  double get fontSizeFactor => 2.0;

  double get headerTextScaleFactor => 0.6;

  TableColumnWidth get defaultTableColumnWidth => const FlexColumnWidth(1.0);

  String textForColumn(int columnIndex, Entry entry) =>
      throw ArgumentError('Could not get a value for $columnIndex from $entry');

  String textForSubEntry(int columnIndex, SubEntry subEntry) =>
      throw ArgumentError(
          'Could not get a value for $columnIndex from $subEntry');

  Widget _tableHeader(String content) => Container(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 3),
        child: Text(
          content,
          textScaleFactor: headerTextScaleFactor,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );

  Widget _tableCell(String content, {Color color}) => Container(
        color: color,
        padding: const EdgeInsets.all(2),
        child: Text(content),
      );

  Widget widgetForSubEntry(int columnIndex, SubEntry subEntry, bool isMulti) =>
      _tableCell(
        textForSubEntry(columnIndex, subEntry),
        color: isMulti ? subEntryColor(subEntry) : null,
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
              children: columns.map(_tableHeader).toList(growable: false),
            ),
            ...places.map(
              (entry) {
                final subEntries = subEntriesForEntry(entry);
                return TableRow(
                  decoration: BoxDecoration(
                    color: subEntries.length == 1
                        ? subEntryColor(subEntries.single)
                        : null,
                    border: Border.all(width: _itemPadding),
                  ),
                  children: Iterable<int>.generate(columns.length).map(
                    (column) {
                      if (isMulti(column)) {
                        if (subEntries.length == 1) {
                          return widgetForSubEntry(
                            column,
                            subEntries.single,
                            false,
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: _itemPadding,
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
                                    true,
                                  );
                                },
                              ),
                            ),
                          );
                        }
                      } else {
                        return _tableCell(textForColumn(column, entry));
                      }
                    },
                  ).toList(growable: false),
                );
              },
            )
          ],
        ),
      );
}

Widget _tableCell(String content, {Color color}) => Container(
      color: color,
      padding: const EdgeInsets.all(2),
      child: Text(content),
    );

const double _itemPadding = 1;
