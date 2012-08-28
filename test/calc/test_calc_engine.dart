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
      //print(['location data set']);
    });

    final distanceElectionHandler = expectAsync1((args) {
      //print(['distance data set']);
    });

    final pluralityElectionHandler = expectAsync1((args) {
      //print(['plurality data set']);
    });

    final condorcetElectionHandler = expectAsync1((args) {
      //print(['condorcet data set']);
    });

    engine.locationDataChanged.add(locationDataHandler);
    engine.distanceElectionChanged.add(distanceElectionHandler);
    engine.pluralityElectionChanged.add(pluralityElectionHandler);
    engine.condorcetElectionChanged.add(condorcetElectionHandler);

    engine.locationData = data;
  }
}
