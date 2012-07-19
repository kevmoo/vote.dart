class TestLocationData {
  static void run() {
    group('LocationData', (){
      test('getCandidateName', _testGetCandidateName);
    });
  }

  static void _testGetCandidateName() {
    expect(LocationData.getCandidateName(0), equals('A'));
    expect(LocationData.getCandidateName(1), equals('B'));
    expect(LocationData.getCandidateName(25), equals('Z'));
    expect(() => LocationData.getCandidateName(26), throwsIllegalArgumentException);

  }

}
