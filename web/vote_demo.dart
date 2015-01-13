library vote.demo;

import 'dart:html';
import 'package:bot_web/bot_retained.dart';
import 'package:vote/calc.dart';
import 'package:vote/html.dart';
import 'package:vote/map.dart';
import 'package:vote/retained.dart';

void main() {
  CanvasElement canvas = querySelector("#content");
  DivElement pluralityDiv = querySelector('#pluralityView');
  DivElement distanceDiv = querySelector('#distanceView');
  DivElement condorcetDiv = querySelector('#condorcetView');
  DivElement canManDiv = querySelector('#canManView');
  DivElement irvDiv = querySelector('#irvView');
  var demo = new VoteDemo(
      canvas, pluralityDiv, distanceDiv, condorcetDiv, canManDiv, irvDiv);
  demo.requestFrame();
}

class VoteDemo extends StageWrapper<RootMapElement> {
  final CalcEngine _calcEngine = new CalcEngine();

  final Map<MapPlayer, num> _playerHues = new Map<MapPlayer, num>();
  final CondorcetView _condorcetView;
  final IrvView _irvView;
  final DistanceView _distanceView;
  final PluralityView _pluralityView;
  final CandidateManagerView _canManView;

  Map<MapPlayer, num> _candidateHues;

  factory VoteDemo(CanvasElement canvas, DivElement pluralityDiv,
      DivElement distanceDiv, DivElement condorcetDiv, DivElement canManDiv,
      DivElement irvDiv) {
    var voterMap = new RootMapElement(canvas.width, canvas.height);

    var distanceView = new DistanceView(distanceDiv);

    var pluralityView = new PluralityView(pluralityDiv);

    var condorcetView = new CondorcetView(condorcetDiv);
    final irvView = new IrvView(irvDiv);

    final canManView = new CandidateManagerView(canManDiv);

    return new VoteDemo._internal(canvas, voterMap, condorcetView,
        pluralityView, distanceView, canManView, irvView);
  }

  VoteDemo._internal(CanvasElement canvas, RootMapElement rootMapElement,
      this._condorcetView, this._pluralityView, this._distanceView,
      this._canManView, this._irvView) : super(canvas, rootMapElement) {
    final mm = new MouseManager(stage);

    _calcEngine.locationDataChanged.listen(_locationDataUpdated);
    _calcEngine.distanceElectionChanged.listen(_distanceElectionUpdated);
    _calcEngine.pluralityElectionChanged.listen(_pluralityElectionUpdated);
    _calcEngine.condorcetElectionChanged.listen(_condorcetElectionUpdated);
    _calcEngine.irvElectionChanged.listen(_irvElectionUpdated);
    _calcEngine.voterHueMapperChanged.listen(_voterHexMapperUpdated);

    rootThing.candidatesMoved.listen((data) => _calcEngine.candidatesMoved());

    _canManView.candidateRemoveRequest.listen(_calcEngine.removeCandidate);

    _canManView.newCandidateRequest.listen((_) => _calcEngine.addCandidate());

    _condorcetView.hoverChanged.listen(
        (_) => _updateHighlightCandidates(_condorcetView.highlightCandidates));

    _irvView.hoverChanged.listen(
        (_) => _updateHighlightCandidates(_irvView.highlightCandidates));

    final initialData = new LocationData.random();

    _calcEngine.locationData = initialData;
  }

  void _updateHighlightCandidates(List candidates) {
    _calcEngine.hoverPair = candidates;
    rootThing.showOnlyPlayers = candidates;
  }

  void _locationDataUpdated(dynamic args) {
    assert(_calcEngine.locationData != null);
    final locData = _calcEngine.locationData;
    rootThing.locationData = locData;
    _canManView.candidates = locData.candidates;
  }

  void _distanceElectionUpdated(dynamic args) {
    assert(_calcEngine.distanceElection != null);
    _distanceView.election = _calcEngine.distanceElection;
    requestFrame();
  }

  void _pluralityElectionUpdated(dynamic args) {
    assert(_calcEngine.pluralityElection != null);
    _pluralityView.election = _calcEngine.pluralityElection;
    requestFrame();
  }

  void _condorcetElectionUpdated(dynamic args) {
    assert(_calcEngine.condorcetElection != null);
    _condorcetView.election = _calcEngine.condorcetElection;
    requestFrame();
  }

  void _irvElectionUpdated(args) {
    assert(_calcEngine.irvElection != null);
    _irvView.election = _calcEngine.irvElection;
    requestFrame();
  }

  void _voterHexMapperUpdated(dynamic args) {
    assert(_calcEngine.voterHexMap != null);
    rootThing.voterHexMap = _calcEngine.voterHexMap;
    requestFrame();
  }

  @override
  void drawFrame(double highResTime) {
    super.drawFrame(highResTime);

    _condorcetView.draw();
    _irvView.draw();
    _pluralityView.draw();
    _distanceView.draw();
    _canManView.draw();
  }
}
