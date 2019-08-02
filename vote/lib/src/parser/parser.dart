import 'package:string_scanner/string_scanner.dart';

import 'ballot_line.dart';

Iterable<BallotLine<String>> parse(String input) => _Parser(input).parse();

class _Parser {
  final StringScanner _scanner;

  _Parser(String input) : _scanner = StringScanner(input);

  Iterable<BallotLine<String>> parse() {
    final ballotLines = <BallotLine<String>>[];

    while (true) {
      // Here = _State.lineStart.
      _scanner.scan(_whitespace);
      if (_scanner.isDone) break;

      // Here = _State.number.
      _scanner.expect(_intRegexp, name: 'Count');
      final count = int.parse(_scanner.lastMatch[0]);

      // Here = _State.colon.
      _scanner.expect(_colonRegexp, name: 'Colon');

      final candidates = <String>[];
      do {
        // Here = _State.candidate.
        _scanner.expect(_candidate, name: 'Candidate');
        candidates.add(_scanner.lastMatch[1].trim());

        // Here = _State.arrow.
      } while (_scanner.scan(_arrow));

      ballotLines.add(BallotLine<String>(count, candidates));

      if (_scanner.isDone) break; // Don't require a newline at EOF.
      _scanner.expect(_whitespaceThenNewline, name: 'Newline');
    }

    // Here = _State.eof.
    return ballotLines;
  }

  static final _arrow = RegExp(r'\s*>');
  static final _whitespace = RegExp(r'\s*');
  static final _whitespaceThenNewline = RegExp(r'[\s\n]*');
  static final _intRegexp = RegExp(r'\s*\d+');
  static final _colonRegexp = RegExp(r'\s*:');
  static final _candidate = RegExp(r'\s*([^>:\n]+)');
}
