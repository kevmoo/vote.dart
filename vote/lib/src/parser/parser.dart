import 'package:string_scanner/string_scanner.dart';

import 'ballot_line.dart';

Iterable<BallotLine<String>> parse(String input) sync* {
  int count;
  List<String> candidates;

  for (var entry in _scan(input)) {
    if (entry is int) {
      // start of a line!

      if (count != null) {
        // we have an existing line! yield it!
        assert(count > 0);
        assert(candidates != null && candidates.isNotEmpty);
        yield BallotLine(count, candidates);
        candidates = null;
      }

      count = entry;
    } else if (entry is String) {
      assert(count != null);
      candidates ??= <String>[];
      candidates.add(entry);
    } else {
      throw UnsupportedError('Cannot part of ${entry.runtimeType} – $entry');
    }
  }

  if (count != null) {
    // we have an existing line! yield it!
    assert(count > 0);
    assert(candidates != null && candidates.isNotEmpty);
    yield BallotLine(count, candidates);
    candidates = null;
  }
}

Iterable _scan(String input) => _Parser(input).scan();

class _Parser {
  final StringScanner _scanner;
  _State _state = _State.lineStart;

  _Parser(String input) : _scanner = StringScanner(input);

  Iterable scan() sync* {
    while (_state != _State.eof) {
      final result = _parser();
      _state = result.nextState;
      if (result.value != null) {
        yield result.value;
      }
    }
  }

  _Result Function() get _parser {
    switch (_state) {
      case _State.lineStart:
        return _parseCountOrEof;
      case _State.number:
        return _parseColon;
      case _State.colon:
        return _parseCandidate;
      case _State.candidate:
        return _arrowOrNewLine;
      case _State.arrow:
        return _parseCandidate;
      default:
        throw UnimplementedError('have not done work on $_state yet');
    }
  }

  _Result _parseCountOrEof() {
    assert(_state == _State.lineStart);
    if (_scanner.scan(_intRegexp)) {
      return _Result<int>(int.parse(_scanner.lastMatch[0]), _State.number);
    }
    if (_scanner.scan(_whitespace)) {
      if (!_scanner.isDone) {
        _scanner.error('Expected a number.');
      }
      return _Result(null, _State.eof);
    }
    _scanner.error('Bad spot!');
  }

  _Result<Null> _parseColon() {
    assert(_state == _State.number);
    _scanner.expect(_colonRegexp, name: 'colon (:)');
    return _Result(null, _State.colon);
  }

  _Result<String> _parseCandidate() {
    assert(_state == _State.colon || _state == _State.arrow);
    _scanner.expect(_candidate, name: 'A candidate');
    final value = _scanner.lastMatch[1].trim();
    assert(value.isNotEmpty);
    return _Result(value, _State.candidate);
  }

  _Result _arrowOrNewLine() {
    if (_scanner.scan(_arrow)) {
      return _Result(null, _State.arrow);
    }
    if (_scanner.scan(_whitespaceThenNewline)) {
      return _Result(null, _State.lineStart);
    }

    _scanner.error('not what I expected');
  }

  static final _arrow = RegExp(r'\s*>');
  static final _whitespace = RegExp(r'\s*');
  static final _whitespaceThenNewline = RegExp(r'[\s\n]*');
  static final _intRegexp = RegExp(r'\s*\d+');
  static final _colonRegexp = RegExp(r'\s*:');
  static final _candidate = RegExp(r'\s*([^>:\n]+)');
}

class _Result<T> {
  final T value;
  final _State nextState;

  _Result(this.value, this.nextState);

  @override
  String toString() => '`$value` - $nextState';
}

enum _State {
  lineStart,
  number,
  colon,
  candidate,
  arrow,
  eof,
}
