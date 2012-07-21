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

  void candidatesMoved() {
    // just force _distanceElection to reprocess existing data
    this.locationData = locationData;
  }

  void set candidateData(Iterable<MapPlayer> value) {
    assert(value != null);
    assert(locationData != null);

    final roCandidates = new ReadOnlyCollection<MapPlayer>(value);

    if(roCandidates.length > 0) {
      final newData = new LocationData(_distanceElectionMapper.input.voters, roCandidates);

      locationData = newData;
    } else {
      print('TODO: we blow up at the moment w/ zero candidates. Probably okay.');
    }
  }

  DistanceElection get distanceElection() => _distanceElectionMapper.output;

  PluralityElection get pluralityElection() => _pluralityElectionMapper.output;

  CondorcetElection get condorcetElection() => _condorcetElectionMapper.output;

  HashMap<MapPlayer, String> get voterHexMap() => _voterHexMapper.output;

  void addCandidate() {
    assert(locationData != null);
    final newData = locationData.cloneAndAddCandidate();
    _distanceElectionMapper.input = newData;
  }

  void removeCandidate(MapPlayer candidate) {
    final newData = locationData.cloneAndRemove(candidate);
    _distanceElectionMapper.input = newData;
  }

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
  extends SendPortValue<LocationData, DistanceElection> {

  _DistanceElectionMapper() : super(spawnFunction(_distanceElectionIsolate));
}

void _distanceElectionIsolate() {
  port.receive((LocationData data, SendPort reply) {
    final distanceElection = new DistanceElection.fromData(data);
    reply.send(distanceElection);
  });
}

class _PluralityElectionMapper
  extends SendPortValue<Collection<PluralityBallot<MapPlayer, MapPlayer>>, PluralityElection> {

  _PluralityElectionMapper() : super(spawnFunction(_pluralityElectionIsolate));
}

void _pluralityElectionIsolate() {
  port.receive((Collection<PluralityBallot<MapPlayer, MapPlayer>> ballots,
      SendPort reply) {
    final pluralityElection = new PluralityElection(ballots);
    reply.send(pluralityElection);
  });
}

class _CondorcetElectionMapper
  extends SendPortValue<Collection<RankedBallot<MapPlayer, MapPlayer>>, CondorcetElection> {

  _CondorcetElectionMapper() : super(spawnFunction(_condorcetElectionIsolate));
}

void _condorcetElectionIsolate() {
  port.receive((Collection<RankedBallot<MapPlayer, MapPlayer>> ballots,
      SendPort reply) {
    final election = new CondorcetElection(ballots);
    reply.send(election);
  });
}

class _VoterHexMapper
  extends SendPortValue<Tuple<DistanceElection, LocationData>, HashMap<MapPlayer, String>> {

  _VoterHexMapper() : super(spawnFunction(_voterHexMapperIsolate));
}

void _voterHexMapperIsolate() {
  port.receive((Tuple<DistanceElection, LocationData> tuple, SendPort reply) {
    final map = new HashMap<MapPlayer, String>();
    for(final b in tuple.Item1.ballots) {
      final candidate = b.choice;
      final hue = LocationData.getHue(candidate);
      map[b.voter] = (new HslColor(hue, 0.5, 0.75)).toRgb().toHex();
    }
    reply.send(map);
  });
}
