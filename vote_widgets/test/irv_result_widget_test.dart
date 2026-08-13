import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:vote/vote.dart';
import 'package:vote_widgets/src/model/candidate.dart';
import 'package:vote_widgets/src/widget/irv_result_widget.dart';

void main() {
  testWidgets('renders single candidate IRV result', (tester) async {
    final c1 = Candidate('A', 0.0);
    final ballots = [
      RankedBallot([c1]),
    ];
    final election = IrvElection(ballots);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Provider<IrvElection<Candidate>>.value(
            value: election,
            child: const IrvResultWidget<Candidate>(),
          ),
        ),
      ),
    );

    expect(find.text('Round 1'), findsOneWidget);
    expect(find.text('A'), findsWidgets);
    expect(find.text('1'), findsWidgets);
  });

  testWidgets('renders multi-round IRV election with elimination', (
    tester,
  ) async {
    final canA = Candidate('A', 0.0);
    final canB = Candidate('B', 60.0);
    final canC = Candidate('C', 120.0);

    final ballots = [
      for (var i = 0; i < 5; i++) RankedBallot([canA, canB, canC]),
      for (var i = 0; i < 4; i++) RankedBallot([canB, canA, canC]),
      for (var i = 0; i < 2; i++) RankedBallot([canC, canA, canB]),
    ];
    final election = IrvElection(ballots);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Provider<IrvElection<Candidate>>.value(
            value: election,
            child: const IrvResultWidget<Candidate>(),
          ),
        ),
      ),
    );

    expect(find.text('Round 1'), findsOneWidget);
    expect(find.text('Round 2'), findsOneWidget);
    expect(find.text('A'), findsWidgets);
    expect(find.text('B'), findsWidgets);
    expect(find.text('C'), findsWidgets);
  });
}
