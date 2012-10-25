library vote;

import 'package:bot/bot.dart';

part 'vote/election_place.dart';
part 'vote/player.dart';
part 'vote/election.dart';
part 'vote/ballot.dart';
part 'vote/ranked_ballot.dart';

part 'vote/plurality_ballot.dart';
part 'vote/plurality_election.dart';
part 'vote/plurality_election_place.dart';

part 'vote/condorcet_election.dart';
part 'vote/condorcet_pair.dart';
part 'vote/condorcet_candidate_profile.dart';

part 'vote/irv_election.dart';
part 'vote/irv_round.dart';
part 'vote/irv_elimination.dart';

Date _last;

void log(String message) {
  final now = new Date.now();
  if(_last != null) {
    final delta = now.difference(_last);
    print([delta, message]);
  }
  else {
    print(message);
  }
  _last = now;
}

int majorityThreshold(int votes) {
  assert(votes > 0);
  return votes ~/ 2 + 1;
}
