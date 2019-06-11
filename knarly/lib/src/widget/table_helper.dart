import 'package:flutter_web/material.dart';

abstract class TableHelper<Entry, SubEntry> {
  const TableHelper();

  List<String> get columns;

  List<SubEntry> subEntries(Entry entry);

  Color subEntryColor(SubEntry subEntry);

  bool isMulti(String column);

  String textForColumn(String columnName, Entry entry) =>
      throw ArgumentError('Could not get a value for $columnName from $entry');

  String textForSubEntry(String columnName, SubEntry subEntry) =>
      throw ArgumentError(
          'Could not get a value for $columnName from $subEntry');

  Widget build(BuildContext context, List<Entry> places) => DefaultTextStyle(
        textAlign: TextAlign.center,
        style: DefaultTextStyle.of(context).style.apply(
              fontSizeFactor: 2.0,
            ),
        child: Container(
          alignment: Alignment.center,
          child: Table(
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
                    children: columns.map(
                      (column) {
                        if (isMulti(column)) {
                          if (subEntries2.length == 1) {
                            return Text(
                                textForSubEntry(column, subEntries2.single));
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
                                    return Text(
                                      textForSubEntry(column, subEntry),
                                      style: TextStyle(
                                        backgroundColor:
                                            subEntryColor(subEntry),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          }
                        } else {
                          return Text(textForColumn(column, entry));
                        }
                      },
                    ).toList(growable: false),
                  );
                },
              )
            ],
          ),
        ),
      );
}

const double _itemPadding = 0.5;

Widget _tableHeader(String content) => Container(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Text(
        content,
        textScaleFactor: 0.6,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
