import 'package:test/test.dart';
import 'package:vote/src/election.dart';
import 'package:vote/src/election_place.dart';
import 'package:vote/src/plurality_ballot.dart';

typedef ElectionFactory = Election<String, ElectionPlace<String>> Function(
  List<PluralityBallot<String>> ballots,
);

void registerPluralityTests(ElectionFactory electionFactory) {
  test('single vote, single winner', () {
    final c1 = 'candidate 1';

    final ballots = [PluralityBallot(c1)];

    final election = electionFactory(ballots);
    expect(election.singleWinner, equals(c1));
    expect(election.places, hasLength(1));

    final firstPlace = election.places[0];
    expect(firstPlace, hasLength(1));
    expect(firstPlace[0], equals(c1));
  });

  test('tied for 1st', () {
    final c1 = 'candidate 1';
    final c2 = 'candidate 2';
    final c3 = 'candidate 3';

    final ballots = [
      ...Iterable.generate(10, (_) => PluralityBallot(c1)),
      ...Iterable.generate(10, (_) => PluralityBallot(c2)),
      ...Iterable.generate(9, (_) => PluralityBallot(c3))
    ];

    final election = electionFactory(ballots);
    expect(election.singleWinner, isNull);
    expect(election.places, hasLength(2));

    final firstPlace = election.places[0];
    expect(firstPlace.place, equals(1));
    expect(firstPlace, [c1, c2]);

    final thirdPlace = election.places[1];
    expect(thirdPlace.place, equals(3));
    expect(thirdPlace, [c3]);
  });
}
