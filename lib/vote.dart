library vote;

import 'package:bot/bot.dart';

part 'src/vote/election_place.dart';
part 'src/vote/player.dart';
part 'src/vote/election.dart';
part 'src/vote/ballot.dart';
part 'src/vote/ranked_ballot.dart';

part 'src/vote/plurality_ballot.dart';
part 'src/vote/plurality_election.dart';
part 'src/vote/plurality_election_place.dart';

part 'src/vote/condorcet_election.dart';
part 'src/vote/condorcet_pair.dart';
part 'src/vote/condorcet_candidate_profile.dart';

part 'src/vote/irv_election.dart';
part 'src/vote/irv_round.dart';
part 'src/vote/irv_elimination.dart';

int majorityThreshold(int votes) {
  assert(votes > 0);
  return votes ~/ 2 + 1;
}
