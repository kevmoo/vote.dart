import 'package:test/test.dart';
import 'package:vote/src/calc.dart';
import 'package:vote/src/map/location_data.dart';

void main() {
  test('CalcEngine', () {
    final engine = new CalcEngine();

    final data = new LocationData.random();

    final locationDataHandler = expectAsync((LocationData arg) {
      expect(engine.locationData, isNot(isNull));
    });

    final distanceElectionHandler = expectAsync((args) {
      expect(engine.distanceElection, isNot(isNull));
    });

    final pluralityElectionHandler = expectAsync((args) {
      expect(engine.pluralityElection, isNot(isNull));
    });

    final condorcetElectionHandler = expectAsync((args) {
      expect(engine.condorcetElection, isNot(isNull));
    });

    engine.locationDataChanged.listen(locationDataHandler);
    engine.distanceElectionChanged.listen(distanceElectionHandler);
    engine.pluralityElectionChanged.listen(pluralityElectionHandler);
    engine.condorcetElectionChanged.listen(condorcetElectionHandler);

    expect(engine.locationData, isNull);
    expect(engine.distanceElection, isNull);
    expect(engine.pluralityElection, isNull);
    expect(engine.condorcetElection, isNull);
    expect(engine.locationData, isNull);

    engine.locationData = data;
  });
}
