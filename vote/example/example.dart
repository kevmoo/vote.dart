import 'package:vote/vote.dart';

void main() {
  const chocolate = 'Chocolate';
  const fudge = 'Fudge';
  const vanilla = 'Vanilla';

  final ballots = [
    for (var i = 0; i < 31; i++)
      RankedBallot(const [fudge, chocolate, vanilla]),
    for (var i = 0; i < 29; i++)
      RankedBallot(const [chocolate, fudge, vanilla]),
    for (var i = 0; i < 40; i++)
      RankedBallot(const [vanilla, chocolate, fudge]),
  ];

  final pluralityElection = PluralityElection(ballots);
  print('Plurality winner: ${pluralityElection.singleWinner}');

  final irvElection = IrvElection(ballots);
  print('IRV winner:       ${irvElection.singleWinner}');

  final condorcetElection = CondorcetElection(ballots);
  print('Condorcet winner: ${condorcetElection.singleWinner}');
}
