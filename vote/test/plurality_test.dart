import 'package:vote/vote.dart';

import 'plurality_test_shared.dart';

void main() {
  registerPluralityTests(
    (ballots, {candidates}) =>
        PluralityElection(ballots, candidates: candidates),
  );
}
