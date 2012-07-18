#import('dart:html');
#import('../../../dartlib/lib/core.dart', prefix:'core');
#import('../../../dartlib/lib/retained.dart');
#import('../../../dartlib/lib/html.dart');

#import('../../lib/vote.dart');
#import('../../lib/map.dart');
#import('../../lib/retained.dart');
#import('../../lib/html.dart');
#import('../../lib/calc.dart');

main(){
  CanvasElement canvas = document.query("#content");
  DivElement pluralityDiv = document.query('#pluralityView');
  DivElement distanceDiv = document.query('#distanceView');
  DivElement condorcetDiv = document.query('#condorcetView');
  var demo = new VoteDemo(canvas, pluralityDiv, distanceDiv, condorcetDiv);
  demo._requestFrame();
}

class VoteDemo{
  final CanvasElement _canvas;
  final Stage _stage;
  final Dragger _dragger;

  final ElectionCalc _calcEngine;

  final RootMapElement _rootMapElement;
  final HashMap<MapPlayer, num> _playerHues;
  final CondorcetView _condorcetView;
  final DistanceView _distanceView;
  final PluralityView _pluralityView;

  HashMap<MapPlayer, num> _candidateHues;

  core.Coordinate _mouseLocation;
  MapPlayer _overCandidate, _dragCandidate;
  bool _frameRequested = false;

  factory VoteDemo(CanvasElement canvas, DivElement pluralityDiv,
    DivElement distanceDiv, DivElement condorcetDiv) {
    var voterMap = new RootMapElement(canvas.width, canvas.height);

    //
    // Create the stage, etc
    //

    final stage = new Stage(canvas, voterMap);

    var distanceView = new DistanceView(distanceDiv);

    var pluralityView = new PluralityView(pluralityDiv);

    var condorcetView = new CondorcetView(condorcetDiv);

    var dragger = new Dragger(canvas);

    return new VoteDemo._internal(canvas, stage, dragger, voterMap, condorcetView, pluralityView, distanceView);
  }

  VoteDemo._internal(this._canvas, this._stage, this._dragger, this._rootMapElement,
    this._condorcetView, this._pluralityView, this._distanceView)
  : _playerHues = new HashMap<MapPlayer, num>(),
    _calcEngine = new ElectionCalc() {
    _dragger.dragDelta.add(_onDrag);
    _dragger.dragStart.add(_onDragStart);

    _canvas.on.mouseMove.add(_canvas_mouseMove);
    _canvas.on.mouseOut.add(_canvas_mouseOut);

    _calcEngine.distanceElectionChanged.add(_distanceElectionUpdated);
    _calcEngine.pluralityElectionChanged.add(_pluralityElectionUpdated);
    _calcEngine.condorcetElectionChanged.add(_condorcetElectionUpdated);
    _calcEngine.voterHueMapperChanged.add(_voterHueMapperUpdated);

    final initialData = new LocationData.random();

    _calcEngine.locationData = initialData;
    _rootMapElement.locationData = initialData;

    _distanceView.setCandidateColorMap(_calcEngine.locationData.getHue);
    _pluralityView.setCandidateColorMap(_calcEngine.locationData.getHue);
    _condorcetView.setCandidateColorMap(_calcEngine.locationData.getHue);
  }

  void _distanceElectionUpdated(Dynamic args) {
    assert(_calcEngine.distanceElection != null);
    _distanceView.election = _calcEngine.distanceElection;
    _requestFrame();
  }

  void _pluralityElectionUpdated(Dynamic args) {
    assert(_calcEngine.pluralityElection != null);
    _pluralityView.election = _calcEngine.pluralityElection;
    _requestFrame();
  }

  void _condorcetElectionUpdated(Dynamic args) {
    assert(_calcEngine.condorcetElection != null);
    _condorcetView.election = _calcEngine.condorcetElection;
    _requestFrame();
  }

  void _voterHueMapperUpdated(Dynamic args) {
    assert(_calcEngine.voterHueMapper != null);
    _rootMapElement.voterHueMapper = _calcEngine.voterHueMapper;
    _requestFrame();
  }

  void _requestFrame(){
    if(!_frameRequested) {
      _frameRequested = true;
      window.webkitRequestAnimationFrame(_onFrame);
    }
  }

  void _onDrag(core.Vector delta) {
    assert(_dragCandidate != null);
    _rootMapElement.dragCandidate(_dragCandidate, delta);
    _requestFrame();
  }

  void _onDragStart(core.CancelableEventArgs e) {
    if(_overCandidate == null) {
      e.cancel();
    } else {
      _dragCandidate = _overCandidate;
    }
  }

  bool _onFrame(num highResTime){
    _stage.draw();

    _condorcetView.draw();
    _pluralityView.draw();
    _distanceView.draw();
    _frameRequested = false;
  }

  void _canvas_mouseMove(MouseEvent e){
    _setMouse(new core.Coordinate(e.offsetX, e.offsetY));
  }

  void _canvas_mouseOut(MouseEvent e){
    _setMouse(null);
  }

  void _setMouse(core.Coordinate value) {
    _mouseLocation = value;
    final hits = Mouse.markMouseOver(_stage, _mouseLocation);
    if(hits != null && hits.length > 0 && hits[0] is CandidateElement) {
      _canvas.style.cursor = 'pointer';
      final CandidateElement ce = hits[0];
      _overCandidate = ce.player;
    } else {
      _canvas.style.cursor = 'auto';
      _overCandidate = null;
    }
    _requestFrame();
  }
}
