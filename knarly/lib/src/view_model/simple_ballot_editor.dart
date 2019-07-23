import 'package:vote/vote.dart';

import '../model/candidate.dart';
import '../model/election_data.dart';
import 'editor.dart';

class SimpleBallotEditor extends KnarlyEditor<ElectionData> {
  SimpleBallotEditor({
    ElectionData electionData,
  }) : super(electionData ?? _sampleData());

  @override
  bool updateSource(ElectionData data) {
    setValue(ElectionData.fromData(
      data.ballots,
      candidates: data.candidates,
    ));
    return true;
  }
}

ElectionData _sampleData() {
  // 1st, 4th, 5th, 7th
  // 3,   1,   2,   1
  var hue = 0.0;
  final cA1 = Candidate('A1', hue);
  final cA2 = Candidate('A2', hue += 360 / 7);
  final cA3 = Candidate('A3', hue += 360 / 7);
  final cB1 = Candidate('B1', hue += 360 / 7);
  final cC1 = Candidate('C1', hue += 360 / 7);
  final cC2 = Candidate('C2', hue += 360 / 7);
  final cD1 = Candidate('D1', hue += 360 / 7);

  final ballots = [
    RankedBallot([cA1, cA2, cA3, cB1, cC1, cC2, cD1]),
    RankedBallot([cA1, cA2, cA3, cB1, cC2, cC1, cD1]),
    RankedBallot([cA2, cA3, cA1, cB1, cC1, cC2, cD1]),
    RankedBallot([cA2, cA3, cA1, cB1, cC2, cC1, cD1]),
    RankedBallot([cA3, cA1, cA2, cB1, cC1, cC2, cD1]),
    RankedBallot([cA3, cA1, cA2, cB1, cC2, cC1, cD1]),
  ];

  return ElectionData.fromData(ballots);
}
