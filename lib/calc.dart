import 'dart:async';

import 'package:bot/bot.dart' hide ReadOnlyCollection;

import 'src/map/distance_election.dart';
import 'src/map/location_data.dart';
import 'src/map/map_player.dart';

import 'src/vote/condorcet_election.dart';
import 'src/vote/irv_election.dart';
import 'src/vote/plurality_ballot.dart';
import 'src/vote/plurality_election.dart';
import 'src/vote/ranked_ballot.dart';

class CalcEngine {
  final ThrottledStream<LocationData, DistanceElection>
      _distanceElectionMapper = new ThrottledStream(_distanceElectionIsolate);

  final ThrottledStream<List<PluralityBallot<MapPlayer, MapPlayer>>,
          PluralityElection> _pluralityElectionMapper =
      new ThrottledStream<List<PluralityBallot<MapPlayer, MapPlayer>>,
          PluralityElection>(_pluralityElectionIsolate);

  final ThrottledStream<List<RankedBallot<MapPlayer, MapPlayer>>,
          CondorcetElection> _condorcetElectionMapper =
      new ThrottledStream<List<RankedBallot<MapPlayer, MapPlayer>>,
          CondorcetElection>(_condorcetElectionIsolate);

  final ThrottledStream<List<RankedBallot<MapPlayer, MapPlayer>>, IrvElection>
      _irvElectionMapper = new ThrottledStream<
          List<RankedBallot<MapPlayer, MapPlayer>>,
          IrvElection>(_irvElectionIsolate);

  final ThrottledStream<Tuple3<DistanceElection, LocationData, List<MapPlayer>>,
          Map<MapPlayer, String>> _voterHexMapper =
      new ThrottledStream<
          Tuple3<DistanceElection, LocationData, List<MapPlayer>>,
          Map<MapPlayer, String>>(_voterHexIsolate);

  final StreamController<LocationData> _locationDataStream =
      new StreamController<LocationData>();

  List<MapPlayer> _highlightCandidates;

  CalcEngine() {
    _distanceElectionMapper.outputStream.listen((args) {
      _distanceElectionChanged();
    });
  }

  LocationData get locationData => _distanceElectionMapper.source;

  void set locationData(LocationData data) {
    requireArgumentNotNull(data, 'data');

    _distanceElectionMapper.source = data;
    _locationDataStream.add(data);
  }

  void candidatesMoved() {
    _distanceElectionMapper.refresh();
    _locationDataStream.add(locationData);
  }

  void set candidateData(Iterable<MapPlayer> value) {
    assert(value != null);
    assert(locationData != null);

    final roCandidates = new List<MapPlayer>.unmodifiable(value);

    if (roCandidates.length > 0) {
      final newData =
          new LocationData(_distanceElectionMapper.source.voters, roCandidates);

      locationData = newData;
    } else {
      print(
          'TODO: we blow up at the moment w/ zero candidates. Probably okay.');
    }
  }

  void set hoverPair(List<MapPlayer> pair) {
    _highlightCandidates = pair;
    _updateVoterHexMapper();
  }

  DistanceElection get distanceElection => _distanceElectionMapper.outputValue;

  PluralityElection get pluralityElection =>
      _pluralityElectionMapper.outputValue;

  CondorcetElection get condorcetElection =>
      _condorcetElectionMapper.outputValue;

  IrvElection get irvElection => _irvElectionMapper.outputValue;

  Map<MapPlayer, String> get voterHexMap => _voterHexMapper.outputValue;

  void addCandidate() {
    assert(locationData != null);
    final newData = locationData.cloneAndAddCandidate();
    locationData = newData;
  }

  void removeCandidate(MapPlayer candidate) {
    final newData = locationData.cloneAndRemove(candidate);
    locationData = newData;
  }

  //
  // Events
  //
  Stream<LocationData> get locationDataChanged => _locationDataStream.stream;

  Stream<DistanceElection> get distanceElectionChanged =>
      _distanceElectionMapper.outputStream;

  Stream<PluralityElection> get pluralityElectionChanged =>
      _pluralityElectionMapper.outputStream;

  Stream<CondorcetElection> get condorcetElectionChanged =>
      _condorcetElectionMapper.outputStream;

  Stream<IrvElection> get irvElectionChanged => _irvElectionMapper.outputStream;

  Stream<Map<MapPlayer, String>> get voterHueMapperChanged =>
      _voterHexMapper.outputStream;

  //
  // Privates
  //

  void _distanceElectionChanged() {
    _pluralityElectionMapper.source = distanceElection.ballots;
    _condorcetElectionMapper.source = distanceElection.ballots;
    _irvElectionMapper.source = distanceElection.ballots;
    _updateVoterHexMapper();
  }

  void _updateVoterHexMapper() {
    final val =
        new Tuple3(distanceElection, locationData, _highlightCandidates);
    _voterHexMapper.source = val;
  }
}

DistanceElection _distanceElectionIsolate(LocationData data) =>
    new DistanceElection.fromData(data);

PluralityElection _pluralityElectionIsolate(
        List<PluralityBallot<MapPlayer, MapPlayer>> ballots) =>
    new PluralityElection(ballots);

CondorcetElection _condorcetElectionIsolate(
        List<RankedBallot<MapPlayer, MapPlayer>> ballots) =>
    new CondorcetElection(ballots);

IrvElection _irvElectionIsolate(
        List<RankedBallot<MapPlayer, MapPlayer>> ballots) =>
    new IrvElection(ballots);

Map<MapPlayer, String> _voterHexIsolate(
    Tuple3<DistanceElection, LocationData, List<MapPlayer>> tuple) {
  final map = new Map<MapPlayer, String>();
  for (final b in tuple.item1.ballots) {
    MapPlayer candidate;
    if (tuple.item3 == null) {
      candidate = b.choice;
    } else {
      // TODO: this will blow up wonderfully if the item is not found
      // need to implement firstOrDefault
      candidate = b.rank.where((c) => tuple.item3.indexOf(c) >= 0).first;
    }
    if (candidate != null) {
      final hue = LocationData.getHue(candidate);
      map[b.voter] = (new HslColor(hue, 0.5, 0.75)).toRgb().toHex();
    }
  }
  return map;
}
