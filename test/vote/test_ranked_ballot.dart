class TestRankedBallot {
  static void run() {
    group('ranked ballot', () {
      final v2 = "voter2";
      final c1 = "candidate 1";
      final c2 = "candidate 2";

      test('no null voters', () {
        expect(() {
          new RankedBallot(null, [c1]);
        }, throwsIllegalArgumentException);
      });

      test('no null candidates', () {
        expect(() {
          new RankedBallot(v2, null);
        }, throwsIllegalArgumentException);
      });

      test('no empty candidates', () {
        expect(() {
          new RankedBallot(v2, []);
        }, throwsIllegalArgumentException);
      });

      test('no dupe candidates', () {
        expect(() {
          new RankedBallot(v2, [c1, c1]);
        }, throwsIllegalArgumentException);
      });

      test('1 candidate is cool', () {
        new RankedBallot(v2, [c1]);
      });

      test('2 candidates is cool', () {
        new RankedBallot(v2, [c1, c2]);
      });
    });
  }
}
