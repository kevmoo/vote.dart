class CalcEngine {
  final _DistanceElectionMapper _distanceElectionMapper = new _DistanceElectionMapper();
  final _PluralityElectionMapper _pluralityElectionMapper = new _PluralityElectionMapper();
  final _CondorcetElectionMapper _condorcetElectionMapper = new _CondorcetElectionMapper();
  final _IrvElectionMapper _irvElectionMapper = new _IrvElectionMapper();
  final _VoterHexMapper _voterHexMapper = new _VoterHexMapper();

  Tuple<MapPlayer, MapPlayer> _hoverPair;

  CalcEngine() {
    _distanceElectionMapper.outputChanged.add((args) {
      _distanceElectionChanged();
    });
  }

  LocationData get locationData => _distanceElectionMapper.input;

  void set locationData(LocationData data) {
    requireArgumentNotNull(data, 'data');
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

  void set hoverPair(Tuple<MapPlayer, MapPlayer> pair) {
    _hoverPair = pair;
    _updateVoterHexMapper();
  }

  DistanceElection get distanceElection => _distanceElectionMapper.output;

  PluralityElection get pluralityElection => _pluralityElectionMapper.output;

  CondorcetElection get condorcetElection => _condorcetElectionMapper.output;

  IrvElection get irvElection => _irvElectionMapper.output;

  HashMap<MapPlayer, String> get voterHexMap => _voterHexMapper.output;

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
  EventRoot<EventArgs> get locationDataChanged =>
      _distanceElectionMapper.inputChanged;

  EventRoot<EventArgs> get distanceElectionChanged =>
      _distanceElectionMapper.outputChanged;

  EventRoot<EventArgs> get pluralityElectionChanged =>
      _pluralityElectionMapper.outputChanged;

  EventRoot<EventArgs> get condorcetElectionChanged =>
      _condorcetElectionMapper.outputChanged;

  EventRoot<EventArgs> get irvElectionChanged =>
      _irvElectionMapper.outputChanged;

  EventRoot<EventArgs> get voterHueMapperChanged =>
      _voterHexMapper.outputChanged;

  //
  // Privates
  //

  void _distanceElectionChanged() {
    _pluralityElectionMapper.input = distanceElection.ballots;
    _condorcetElectionMapper.input = distanceElection.ballots;
    _irvElectionMapper.input = distanceElection.ballots;
    _updateVoterHexMapper();
  }

  void _updateVoterHexMapper() {
    final val = new Tuple3(distanceElection, locationData, _hoverPair);
    _voterHexMapper.input = val;
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

class _IrvElectionMapper
  extends SendPortValue<Collection<RankedBallot<MapPlayer, MapPlayer>>, IrvElection> {

  _IrvElectionMapper() : super(spawnFunction(_irvElectionIsolate));
}

void _irvElectionIsolate() {
  port.receive((Collection<RankedBallot<MapPlayer, MapPlayer>> ballots,
      SendPort reply) {
    final election = new IrvElection(ballots);
    reply.send(election);
  });
}

class _VoterHexMapper
  extends SendPortValue<Tuple3<DistanceElection, LocationData, Tuple<MapPlayer, MapPlayer>>, HashMap<MapPlayer, String>> {

  _VoterHexMapper() : super(spawnFunction(_voterHexMapperIsolate));
}

void _voterHexMapperIsolate() {
  port.receive((Tuple3<DistanceElection, LocationData, Tuple<MapPlayer, MapPlayer>> tuple, SendPort reply) {
    final map = new HashMap<MapPlayer, String>();
    for(final b in tuple.item1.ballots) {
      MapPlayer candidate;
      if(tuple.item3 == null) {
        candidate = b.choice;
      } else {
        // TODO: this will blow up wonderfully if the item is not found
        // need to implement firstOrDefault
        candidate = b.rank.filter((c) => c == tuple.item3.item1 || c == tuple.item3.item2).first();
      }
      if(candidate != null) {
        final hue = LocationData.getHue(candidate);
        map[b.voter] = (new HslColor(hue, 0.5, 0.75)).toRgb().toHex();
      }
    }
    reply.send(map);
  });
}
