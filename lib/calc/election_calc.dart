class ElectionCalc {
  final _DistanceElectionMapper _distanceElectionMapper;
  final _PluralityElectionMapper _pluralityElectionMapper;
  final _CondorcetElectionMapper _condorcetElectionMapper;
  final _VoterHexMapper _voterHexMapper;

  ElectionCalc() :
    _distanceElectionMapper = new _DistanceElectionMapper(),
    _pluralityElectionMapper = new _PluralityElectionMapper(),
    _condorcetElectionMapper = new _CondorcetElectionMapper(),
    _voterHexMapper = new _VoterHexMapper() {
    _distanceElectionMapper.outputChanged.add((args) {
      _distanceElectionChanged();
    });
  }

  LocationData get locationData() => _distanceElectionMapper.input;

  void set locationData(LocationData data) {
    assert(data != null);
    _distanceElectionMapper.input = data;
  }

  DistanceElection get distanceElection() => _distanceElectionMapper.output;

  PluralityElection get pluralityElection() => _pluralityElectionMapper.output;

  CondorcetElection get condorcetElection() => _condorcetElectionMapper.output;

  HashMap<MapPlayer, String> get voterHexMap() => _voterHexMapper.output;

  //
  // Events
  //
  EventRoot<EventArgs> get locationDataChanged() =>
      _distanceElectionMapper.inputChanged;

  EventRoot<EventArgs> get distanceElectionChanged() =>
      _distanceElectionMapper.outputChanged;

  EventRoot<EventArgs> get pluralityElectionChanged() =>
      _pluralityElectionMapper.outputChanged;

  EventRoot<EventArgs> get condorcetElectionChanged() =>
      _condorcetElectionMapper.outputChanged;

  EventRoot<EventArgs> get voterHueMapperChanged() =>
      _voterHexMapper.outputChanged;

  //
  // Privates
  //

  void _distanceElectionChanged() {
    _pluralityElectionMapper.input = distanceElection.ballots;
    _condorcetElectionMapper.input = distanceElection.ballots;
    _voterHexMapper.input = new Tuple(distanceElection, locationData);
  }
}

class _DistanceElectionMapper
  extends SlowMapper<LocationData, DistanceElection> {

  final SendPort _port;
  _DistanceElectionMapper() : _port = spawnFunction(_distanceElectionIsolate);

  Future<DistanceElection> getFuture(value) => _port.call(value);
}

void _distanceElectionIsolate() {
  port.receive((LocationData data, SendPort reply) {
    final distanceElection = new DistanceElection.fromData(data);
    reply.send(distanceElection);
  });
}

class _PluralityElectionMapper
  extends SlowMapper<Collection<PluralityBallot<MapPlayer, MapPlayer>>, PluralityElection> {

  final SendPort _port;
  _PluralityElectionMapper() : _port = spawnFunction(_pluralityElectionIsolate);

  Future<PluralityElection> getFuture(value) => _port.call(value);
}

void _pluralityElectionIsolate() {
  port.receive((Collection<PluralityBallot<MapPlayer, MapPlayer>> ballots,
      SendPort reply) {
    final pluralityElection = new PluralityElection(ballots);
    reply.send(pluralityElection);
  });
}

class _CondorcetElectionMapper
  extends SlowMapper<Collection<RankedBallot<MapPlayer, MapPlayer>>, CondorcetElection> {

  final SendPort _port;
  _CondorcetElectionMapper() : _port = spawnFunction(_condorcetElectionIsolate);

  Future<CondorcetElection> getFuture(value) => _port.call(value);
}

void _condorcetElectionIsolate() {
  port.receive((Collection<RankedBallot<MapPlayer, MapPlayer>> ballots,
      SendPort reply) {
    final election = new CondorcetElection(ballots);
    reply.send(election);
  });
}

class _VoterHexMapper
  extends SlowMapper<Tuple<DistanceElection, LocationData>, HashMap<MapPlayer, String>> {

  final SendPort _port;
  _VoterHexMapper() : _port = spawnFunction(_voterHexMapperIsolate);

  Future<HashMap<MapPlayer, String>> getFuture(value) => _port.call(value);
}

void _voterHexMapperIsolate() {
  port.receive((Tuple<DistanceElection, LocationData> tuple, SendPort reply) {
    final map = new HashMap<MapPlayer, String>();
    for(final b in tuple.Item1.ballots) {
      final candidate = b.choice;
      final hue = tuple.Item2.getHue(candidate);
      map[b.voter] = (new HslColor(hue, 0.5, 0.75)).toRgb().toHex();
    }
    reply.send(map);
  });
}
