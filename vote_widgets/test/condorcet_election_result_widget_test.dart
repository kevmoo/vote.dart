import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vote/vote.dart';
import 'package:vote_widgets/src/model/candidate.dart';
import 'package:vote_widgets/src/widget/condorcet_election_result_widget.dart';

void main() {
  testWidgets('renders Condorcet election result and toggles display mode', (
    tester,
  ) async {
    final canA = Candidate('A', 0.0);
    final canB = Candidate('B', 60.0);

    final ballots = [
      for (var i = 0; i < 3; i++) RankedBallot([canA, canB]),
      for (var i = 0; i < 2; i++) RankedBallot([canB, canA]),
    ];
    final election = CondorcetElection(ballots);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CondorcetElectionResultWidget<Candidate>(election: election),
        ),
      ),
    );

    expect(find.text('A'), findsWidgets);
    expect(find.text('B'), findsWidgets);
    expect(find.text('3>2'), findsOneWidget);

    // Tap to cycle to simple display mode
    await tester.tap(find.byType(CondorcetElectionResultWidget<Candidate>));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.check), findsOneWidget);

    // Tap to cycle to delta display mode
    await tester.tap(find.byType(CondorcetElectionResultWidget<Candidate>));
    await tester.pumpAndSettle();

    expect(find.text('+1'), findsOneWidget);
  });
}
