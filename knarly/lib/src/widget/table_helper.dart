import 'package:flutter_web/material.dart';

abstract class TableHelper<Entry, SubEntry> {
  const TableHelper();

  List<String> get columns;

  List<SubEntry> subEntries(Entry entry);

  Color subEntryColor(SubEntry subEntry);

  bool isMulti(int columnIndex);

  double get fontSizeFactor => 2.0;

  TableColumnWidth get defaultTableColumnWidth => const FlexColumnWidth(1.0);

  String textForColumn(int columnIndex, Entry entry) =>
      throw ArgumentError('Could not get a value for $columnIndex from $entry');

  String textForSubEntry(int columnIndex, SubEntry subEntry) =>
      throw ArgumentError(
          'Could not get a value for $columnIndex from $subEntry');

  Widget build(BuildContext context, List<Entry> places) => DefaultTextStyle(
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
                final subEntries2 = subEntries(entry);
                return TableRow(
                  decoration: BoxDecoration(
                    color: subEntries2.length == 1
                        ? subEntryColor(subEntries2.single)
                        : null,
                    border: Border.all(width: _itemPadding),
                  ),
                  children: Iterable<int>.generate(columns.length).map(
                    (column) {
                      if (isMulti(column)) {
                        if (subEntries2.length == 1) {
                          return _tableCell(
                            textForSubEntry(column, subEntries2.single),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: _itemPadding,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: List.generate(
                                subEntries2.length,
                                (subEntryIndex) {
                                  final subEntry = subEntries2[subEntryIndex];
                                  return _tableCell(
                                    textForSubEntry(column, subEntry),
                                    color: subEntryColor(subEntry),
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

Widget _tableHeader(String content) => Container(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 3),
      child: Text(
        content,
        textScaleFactor: 0.6,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
