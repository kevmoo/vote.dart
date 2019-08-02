import 'package:string_scanner/string_scanner.dart';

import 'ballot_line.dart';

Iterable<BallotLine<String>> parse(String input) sync* {
  final _scanner = StringScanner(input);

  for (;;) {
    _scanner.scan(_whitespace);
    if (_scanner.isDone) break;

    _scanner.expect(_intRegexp, name: 'a number greater than 0');
    final count = int.parse(_scanner.lastMatch[0]);
    if (count <= 0) {
      _scanner.error('expected a number greater than 0.');
    }

    _scanner.expect(_colonRegexp, name: 'a colon (:)');

    final candidates = <String>[];
    do {
      _scanner.expect(_candidate, name: 'a candidate');
      candidates.add(_scanner.lastMatch[1]);
    } while (_scanner.scan(_arrow));

    yield BallotLine<String>(count, candidates);

    if (_scanner.isDone) break; // Don't require a newline at EOF.
    _scanner.expect(_whitespaceThenNewline, name: 'a newline');
  }

  assert(_scanner.isDone);
}

final _arrow = RegExp(r'\s*>');
final _whitespace = RegExp(r'\s*');

/// Any amount of whitespace, at least one newline, then any amount of
/// whitespace and/or newlines.
final _whitespaceThenNewline = RegExp(r'\s*\n[\s\n]*');
final _intRegexp = RegExp(r'\s*\d+');
final _colonRegexp = RegExp(r'\s*:');
final _candidate = RegExp(r'\s*([^\s>:\n]([^>:\n]*[^\s>:\n])?)');
