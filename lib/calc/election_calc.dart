class ElectionCalc {
  final EventHandle<EventArgs> _distanceElectionChangedHandle;
  final EventHandle<EventArgs> _pluralityElectionChangedHandle;
  final EventHandle<EventArgs> _condorcetElectionChangedHandle;
  final EventHandle<EventArgs> _voterHueMapperChangedHandle;

  final SendPort _distanceElectionSendPort;
  final SendPort _pluralityElectionSendPort;
  final SendPort _condorcetElectionSendPort;
  final SendPort _voterHueMapperSendPort;

  LocationData _locationData;
  DistanceElection _distanceElection;
  PluralityElection _pluralityElection;
  CondorcetElection _condorcetElection;
  Func1<MapPlayer, num> _voterHueMapper;

  ElectionCalc() :
    _distanceElectionSendPort = spawnFunction(_distanceElectionIsolate),
    _pluralityElectionSendPort = spawnFunction(_pluralityElectionIsolate),
    _condorcetElectionSendPort = spawnFunction(_condorcetElectionIsolate),
    _voterHueMapperSendPort = spawnFunction(_voterHueMapperIsolate),
    _distanceElectionChangedHandle = new EventHandle<EventArgs>(),
    _pluralityElectionChangedHandle = new EventHandle<EventArgs>(),
    _condorcetElectionChangedHandle = new EventHandle<EventArgs>(),
    _voterHueMapperChangedHandle = new EventHandle<EventArgs>();

  LocationData get locationData() => _locationData;

  DistanceElection get distanceElection() => _distanceElection;

  PluralityElection get pluralityElection() => _pluralityElection;

  CondorcetElection get condorcetElection() => _condorcetElection;

  Func1<MapPlayer, num> get voterHueMapper() => _voterHueMapper;

  void set locationData(LocationData data) {
    assert(data != null);
    _locationData = data;
    final future = _distanceElectionSendPort.call(data);
    future.then(_setDistanceElection);
  }

  //
  // Events
  //
  EventRoot<EventArgs> get distanceElectionChanged() =>
      _distanceElectionChangedHandle;

  EventRoot<EventArgs> get pluralityElectionChanged() =>
      _pluralityElectionChangedHandle;

  EventRoot<EventArgs> get condorcetElectionChanged() =>
      _condorcetElectionChangedHandle;

  EventRoot<EventArgs> get voterHueMapperChanged() =>
      _voterHueMapperChangedHandle;

  //
  // Privates
  //

  void _setDistanceElection(DistanceElection value) {
    assert(value != null);
    _distanceElection = value;
    _distanceElectionChangedHandle.fireEvent(EventArgs.empty);

    final pFuture = _pluralityElectionSendPort.call(_distanceElection.ballots);
    pFuture.then(_setPluralityElection);

    final cFuture = _condorcetElectionSendPort.call(_distanceElection.ballots);
    cFuture.then(_setCondorcetElection);

    final mFuture = _voterHueMapperSendPort.call(_distanceElection.ballots);
    mFuture.then(_setVoterHueMapper);
  }

  void _setPluralityElection(PluralityElection value) {
    assert(value != null);
    _pluralityElection = value;
    _pluralityElectionChangedHandle.fireEvent(EventArgs.empty);
  }

  void _setCondorcetElection(CondorcetElection value) {
    assert(value != null);
    _condorcetElection = value;
    _condorcetElectionChangedHandle.fireEvent(EventArgs.empty);
  }

  void _setVoterHueMapper(HashMap value) {
    assert(value != null);
    _voterHueMapper = (mp) {
      final candidate = value[mp];
      return _locationData.getHue(candidate);
    };
    _voterHueMapperChangedHandle.fireEvent(EventArgs.empty);
  }
}

void _distanceElectionIsolate() {
  port.receive((LocationData data, SendPort reply) {
    final distanceElection = new DistanceElection.fromData(data);
    reply.send(distanceElection);
  });
}

void _pluralityElectionIsolate() {
  port.receive((Collection<PluralityBallot<MapPlayer, MapPlayer>> ballots,
      SendPort reply) {
    final pluralityElection = new PluralityElection(ballots);
    reply.send(pluralityElection);
  });
}

void _condorcetElectionIsolate() {
  port.receive((Collection<RankedBallot<MapPlayer, MapPlayer>> ballots,
      SendPort reply) {
    final election = new CondorcetElection(ballots);
    reply.send(election);
  });
}

void _voterHueMapperIsolate() {
  port.receive((Collection<PluralityBallot<MapPlayer, MapPlayer>> ballots,
      SendPort reply) {
    final map = new HashMap<MapPlayer, MapPlayer>();
    for(final b in ballots) {
      map[b.voter] = b.choice;
    }
    reply.send(map);
  });
}
