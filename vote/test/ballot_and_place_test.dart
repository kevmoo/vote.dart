import 'package:test/test.dart';
import 'package:vote/vote.dart';

import 'test_util.dart';

void main() {
  group('ApprovalBallot', () {
    test('cannot have empty candidates', () {
      expect(() => ApprovalBallot<String>(const {}), throwsAssertionError);
    });

    test('valid ballot, referencedCandidates, and toString', () {
      final b = ApprovalBallot(const {'A', 'B'});
      expect(b.choices, {'A', 'B'});
      expect(b.referencedCandidates(), {'A', 'B'});
      expect(b.toString(), 'ApprovalBallot(A ,B)');
    });
  });

  group('PluralityBallot', () {
    test('valid ballot, referencedCandidates, and toString', () {
      const b = PluralityBallot('Candidate A');
      expect(b.choice, 'Candidate A');
      expect(b.referencedCandidates(), ['Candidate A']);
      expect(b.toString(), 'PluralityBallot(Candidate A)');
    });
  });

  group('ElectionPlace', () {
    test('place properties and toString', () {
      final p1 = ElectionPlace(1, const ['A', 'B']);
      expect(p1.place, 1);
      expect(p1.topPlace, isTrue);
      expect(p1.length, 2);
      expect(p1, ['A', 'B']);
      expect(p1.toString(), 'Place: 1; [A, B]');

      final p2 = ElectionPlace(2, const ['C']);
      expect(p2.place, 2);
      expect(p2.topPlace, isFalse);
      expect(p2.length, 1);
      expect(p2.toString(), 'Place: 2; [C]');
    });

    test('asserts on invalid place or empty candidates', () {
      expect(() => ElectionPlace(0, const ['A']), throwsAssertionError);
      expect(() => ElectionPlace(1, const <String>[]), throwsAssertionError);
    });
  });

  group('PluralityElectionPlace', () {
    test('properties and toString', () {
      final p = PluralityElectionPlace(1, const ['A'], 10);
      expect(p.place, 1);
      expect(p.voteCount, 10);
      expect(p.topPlace, isTrue);
      expect(p.toString(), 'Votes: 10; Place: 1; [A]');
    });

    test('asserts on negative vote count', () {
      expect(
        () => PluralityElectionPlace(1, const ['A'], -1),
        throwsAssertionError,
      );
    });
  });
}
