import 'dart:html';
import 'package:bot/bot.dart';
import 'package:bot/html.dart';
import 'package:bot/retained.dart';
import 'package:vote.dart/calc.dart';
import 'package:vote.dart/html.dart';
import 'package:vote.dart/map.dart';
import 'package:vote.dart/retained.dart';
import 'package:vote.dart/vote.dart';

main(){
  CanvasElement canvas = query("#content");
  DivElement pluralityDiv = query('#pluralityView');
  DivElement distanceDiv = query('#distanceView');
  DivElement condorcetDiv = query('#condorcetView');
  DivElement canManDiv = query('#canManView');
  DivElement irvDiv = query('#irvView');
  var demo = new VoteDemo(canvas, pluralityDiv, distanceDiv, condorcetDiv,
      canManDiv, irvDiv);
  demo.requestFrame();
}

class VoteDemo extends StageWrapper<RootMapElement> {

  final CalcEngine _calcEngine = new CalcEngine();

  final HashMap<MapPlayer, num> _playerHues = new HashMap<MapPlayer, num>();
  final CondorcetView _condorcetView;
  final IrvView _irvView;
  final DistanceView _distanceView;
  final PluralityView _pluralityView;
  final CandidateManagerView _canManView;

  HashMap<MapPlayer, num> _candidateHues;

  factory VoteDemo(CanvasElement canvas, DivElement pluralityDiv,
    DivElement distanceDiv, DivElement condorcetDiv, DivElement canManDiv,
    DivElement irvDiv) {
    var voterMap = new RootMapElement(canvas.width, canvas.height);

    //
    // Create the stage, etc
    //

    var distanceView = new DistanceView(distanceDiv);

    var pluralityView = new PluralityView(pluralityDiv);

    var condorcetView = new CondorcetView(condorcetDiv);
    final irvView = new IrvView(irvDiv);

    final canManView = new CandidateManagerView(canManDiv);

    return new VoteDemo._internal(canvas, voterMap,
      condorcetView, pluralityView, distanceView, canManView, irvView);
  }

  VoteDemo._internal(CanvasElement canvas, RootMapElement rootMapElement,
      this._condorcetView, this._pluralityView, this._distanceView,
      this._canManView, this._irvView) :
        super(canvas, rootMapElement) {

     final mm = new MouseManager(stage);

    _calcEngine.locationDataChanged.add(_locationDataUpdated);
    _calcEngine.distanceElectionChanged.add(_distanceElectionUpdated);
    _calcEngine.pluralityElectionChanged.add(_pluralityElectionUpdated);
    _calcEngine.condorcetElectionChanged.add(_condorcetElectionUpdated);
    _calcEngine.irvElectionChanged.add(_irvElectionUpdated);
    _calcEngine.voterHueMapperChanged.add(_voterHexMapperUpdated);

    rootThing.candidatesMoved.add((data) {
      _calcEngine.candidatesMoved();
    });

    _canManView.candidateRemoveRequest.add((data) {
      _calcEngine.removeCandidate(data);
    });

    _canManView.newCandidateRequest.add((args) {
      _calcEngine.addCandidate();
    });

    _condorcetView.hoverChanged.add((args) {
      _updateHighlightCandidates(_condorcetView.highlightCandidates);
    });

    _irvView.hoverChanged.add((args) {
      _updateHighlightCandidates(_irvView.highlightCandidates);
    });

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

  void drawFrame(double highResTime){
    super.drawFrame(highResTime);

    _condorcetView.draw();
    _irvView.draw();
    _pluralityView.draw();
    _distanceView.draw();
    _canManView.draw();
  }
}
