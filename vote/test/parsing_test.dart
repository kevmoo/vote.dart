import 'dart:convert';

import 'package:test/test.dart';
import 'package:vote/src/parser/ballot_line.dart';
import 'package:vote/src/parser/parser.dart';
import 'package:vote/vote.dart';

void _test(String name, String input, List<BallotLine> expectedResult) {
  test(name, () {
    final output = parse(input).toList();
    expect(output, expectedResult);
  });
}

void main() {
  test('parse', () {
    final chocolate = 'Chocolate';
    final fudge = 'Fudge';
    final vanilla = 'Vanilla';

    final ballots = [
      for (var i = 0; i < 31; i++) RankedBallot([fudge, chocolate, vanilla]),
      for (var i = 0; i < 29; i++) RankedBallot([chocolate, fudge, vanilla]),
      for (var i = 0; i < 40; i++) RankedBallot([vanilla, chocolate, fudge]),
    ];

    final linesText = BallotLines<String>.fromBallots(ballots).text;

    expect(
      BallotLines<String>.parse(linesText, (set) => Map.fromIterable(set)).text,
      linesText,
    );

    final shuffledLines = LineSplitter.split(linesText).toList(growable: false)
      ..shuffle();

    expect(
      BallotLines<String>.parse(
          shuffledLines.join('\n'), (set) => Map.fromIterable(set)).text,
      linesText,
    );
  });

  group('valid input', () {
    _test('empty', '', []);

    _test('whitespace', '  \n\t  \t', []);

    _test(
      'simple',
      '1:a',
      [
        BallotLine(1, ['a']),
      ],
    );

    _test(
      'simple with extra whitespace',
      '\n\t  1  :   a   \n\n',
      [
        BallotLine(1, ['a']),
      ],
    );

    _test(
      'candidates with whitespace',
      r'''
 1 : a

 2 : a > b

42 : bob jones > happy "bob" george  

''',
      [
        BallotLine(1, ['a']),
        BallotLine(2, ['a', 'b']),
        BallotLine(42, ['bob jones', 'happy "bob" george']),
      ],
    );
  });
}
