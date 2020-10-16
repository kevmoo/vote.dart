// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:string_scanner/string_scanner.dart';

import 'ballot_line.dart';

Iterable<BallotLine<String>> parse(String input) sync* {
  final _scanner = StringScanner(input);

  final _caseMatches = <String, String>{};

  for (;;) {
    _scanner.scan(_whitespace);
    if (_scanner.isDone) break;

    _scanner.expect(_intRegexp, name: 'a number greater than 0');
    final count = int.parse(_scanner.lastMatch![1]!);
    if (count <= 0) {
      _scanner.error('expected a number greater than 0.');
    }

    _scanner.expect(_colonRegexp, name: 'a colon (:)');

    final candidates = <String>[];
    do {
      _scanner.expect(_candidate, name: 'a candidate');
      var match = _scanner.lastMatch![1]!;

      match = _caseMatches.putIfAbsent(match.toLowerCase(), () => match);

      if (candidates.contains(match)) {
        _scanner.error('Cannot have duplicate values.');
      }
      candidates.add(match);
    } while (_scanner.scan(_arrow));

    yield BallotLine<String>(count, candidates);

    if (_scanner.isDone) break; // Don't require a newline at EOF.
    _scanner.expect(_newLineThanAnyWhitespace, name: 'a newline');
  }

  assert(_scanner.isDone);
}

const _optionalSpaceOrTab = r'[ \t]*';

final _arrow = RegExp(r'>' + _optionalSpaceOrTab);
final _whitespace = RegExp(r'\s*');

/// Any amount of whitespace, at least one newline, then any amount of
/// whitespace and/or newlines.
final _newLineThanAnyWhitespace = RegExp(r'\n[\s]*');
final _intRegexp = RegExp(r'(\d+)' + _optionalSpaceOrTab);
final _colonRegexp = RegExp(r':' + _optionalSpaceOrTab);
final _candidate = RegExp(
  r'([^\s>:\n]([^>:\n]*[^\s>:\n])?)' + _optionalSpaceOrTab,
);
