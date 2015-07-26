library vote.vote.vote_util;

int majorityThreshold(int votes) {
  assert(votes > 0);
  return votes ~/ 2 + 1;
}
