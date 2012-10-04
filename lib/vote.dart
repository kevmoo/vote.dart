#library('vote');

#import('package:bot/bot.dart');

#source('vote/election_place.dart');
#source('vote/player.dart');
#source('vote/election.dart');
#source('vote/ballot.dart');
#source('vote/ranked_ballot.dart');

#source('vote/plurality_ballot.dart');
#source('vote/plurality_election.dart');
#source('vote/plurality_election_place.dart');

#source('vote/condorcet_election.dart');
#source('vote/condorcet_pair.dart');
#source('vote/condorcet_candidate_profile.dart');

#source('vote/irv_election.dart');
#source('vote/irv_round.dart');
#source('vote/irv_elimination.dart');

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
