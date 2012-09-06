class TestCalcEngine {
  static void run() {
    group('CalcEngine', () {
      test('base', _testBase);
    });
  }

  static void _testBase() {
    final engine = new CalcEngine();

    final data = new LocationData.random();

    final locationDataHandler = expectAsync1((EventArgs arg) {
      expect(engine.locationData, isNot(isNull));
    });

    final distanceElectionHandler = expectAsync1((args) {
      expect(engine.distanceElection, isNot(isNull));
    });

    final pluralityElectionHandler = expectAsync1((args) {
      expect(engine.pluralityElection, isNot(isNull));
    });

    final condorcetElectionHandler = expectAsync1((args) {
      expect(engine.condorcetElection, isNot(isNull));
    });

    engine.locationDataChanged.add(locationDataHandler);
    engine.distanceElectionChanged.add(distanceElectionHandler);
    engine.pluralityElectionChanged.add(pluralityElectionHandler);
    engine.condorcetElectionChanged.add(condorcetElectionHandler);

    expect(engine.locationData, isNull);
    expect(engine.distanceElection, isNull);
    expect(engine.pluralityElection, isNull);
    expect(engine.condorcetElection, isNull);
    expect(engine.locationData, isNull);

    engine.locationData = data;
  }
}
