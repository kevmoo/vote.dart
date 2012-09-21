class TestLocationData {
  static void run() {
    group('LocationData', (){
      test('getCandidateName', _testGetCandidateName);
      test('cloneAndAddCandidate', _testCloneAndAddRemoveCandidate);
    });
  }

  static void _testCloneAndAddRemoveCandidate() {
    LocationData data = new LocationData.random();

    expect(data.candidates, hasLength(5));
    expect($(data.candidates).map((mp) => mp.name),
      orderedEquals(['A', 'B', 'C', 'D', 'E']));

    final canC = data.candidates[2];
    expect(canC.name, equals('C'));

    data = data.cloneAndRemove(canC);
    expect(data.candidates, hasLength(4));
    expect($(data.candidates).map((mp) => mp.name),
      orderedEquals(['A', 'B', 'D', 'E']));

    data = data.cloneAndAddCandidate();
    expect(data.candidates, hasLength(5));
    expect($(data.candidates).map((mp) => mp.name),
      orderedEquals(['A', 'B', 'C', 'D', 'E']));

    data = data.cloneAndAddCandidate();
    expect(data.candidates, hasLength(6));
    expect($(data.candidates).map((mp) => mp.name),
      orderedEquals(['A', 'B', 'C', 'D', 'E', 'F']));

  }

  static void _testGetCandidateName() {
    expect(LocationData.getCandidateName(0), equals('A'));
    expect(LocationData.getCandidateName(1), equals('B'));
    expect(LocationData.getCandidateName(25), equals('Z'));
    expect(() => LocationData.getCandidateName(26), throwsIllegalArgumentException);
  }

}
