import 'package:string_scanner/string_scanner.dart';

import 'ballot_line.dart';

Iterable<BallotLine<String>> parse(String input) sync* {
  final _scanner = StringScanner(input);

  for (;;) {
    _scanner.scan(_whitespace);
    if (_scanner.isDone) break;

    _scanner.expect(_intRegexp, name: 'Count');
    final count = int.parse(_scanner.lastMatch[0]);

    _scanner.expect(_colonRegexp, name: 'Colon');

    final candidates = <String>[];
    do {
      _scanner.expect(_candidate, name: 'Candidate');
      candidates.add(_scanner.lastMatch[1].trim());
    } while (_scanner.scan(_arrow));

    yield BallotLine<String>(count, candidates);

    if (_scanner.isDone) break; // Don't require a newline at EOF.
    _scanner.expect(_whitespaceThenNewline, name: 'Newline');
  }

  assert(_scanner.isDone);
}

final _arrow = RegExp(r'\s*>');
final _whitespace = RegExp(r'\s*');
final _whitespaceThenNewline = RegExp(r'[\s\n]*');
final _intRegexp = RegExp(r'\s*\d+');
final _colonRegexp = RegExp(r'\s*:');
final _candidate = RegExp(r'\s*([^>:\n]+)');
