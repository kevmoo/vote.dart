#import('dart:html');
#import('../../../dartlib/lib/core.dart', prefix:'core');
#import('../../../dartlib/lib/retained.dart');
#import('../../lib/vote.dart');
#import('../../lib/map.dart');
#import('../../lib/retained.dart');
#import('../../lib/html.dart');

main(){
  CanvasElement canvas = document.query("#content");
  DivElement pluralityDiv = document.query('#pluralityView');
  DivElement distanceDiv = document.query('#distanceView');
  DivElement condorcetDiv = document.query('#condorcetView');
  var demo = new VoteDemo(canvas, pluralityDiv, distanceDiv, condorcetDiv);
  demo.requestFrame();
}

class VoteDemo{
  final CanvasElement _canvas;
  final Stage _stage;
  final RootMapElement _voterMap;
  final HashMap<MapPlayer, num> _candidateHues;
  final HashMap<MapPlayer, num> _playerHues;
  final DistanceElection _mapElection;
  final CondorcetView _condorcetView;
  final DistanceView _distanceView;
  final PluralityView _pluralityView;

  core.Coordinate _mouse;
  bool _frameRequested = false;

  factory VoteDemo(CanvasElement canvas, DivElement pluralityDiv,
    DivElement distanceDiv, DivElement condorcetDiv) {
    var voterMap = new RootMapElement(canvas.width, canvas.height);

    final span = 20;
    final spanTweak = span / (span - 1);

    // 100 voters from 1,1 to 10,10
    final voters = new List<MapPlayer>();
    for(var i = 0; i < span; i++) {
      for(var j = 0; j < span; j++) {
        voters.add(new MapPlayer(new core.Coordinate(i * spanTweak, j * spanTweak)));
      }
    }

    // silly spinning wheels to get a semi-random value out of Math.random
    final blah = Clock.now() % 1000;
    for(int i = 0; i < blah; i++) {
      Math.random();
    }

    final coords = new List<core.Vector>();
    final middle = new core.Vector(0.5, 0.5);
    coords.add(middle);

    final bool mirror = false;

    for(var i = 0; i < 4; i++) {
      var coord = new core.Vector(Math.random(), Math.random());
      coords.add(coord);
      if(mirror) {
        final delta = middle - coord;
        coords.add(middle + delta);
        i++;
      }
    }

    final candidates = new List<MapPlayer>();
    core.$(coords)
      .select((c) => c.scale(span))
      .forEachWithIndex((c,i) {
        final candidate = new MapPlayer(c);
        candidate.name = new String.fromCharCodes([i+65]);
        candidates.add(candidate);
      });


    //
    // Create the stage, etc
    //

    final stage = new Stage(canvas, voterMap);

    final HashMap<MapPlayer, num> candidateHues = new HashMap<MapPlayer, num>();

    var index = 0;
    candidates.forEach((c) {
      final spot = 360 * index / candidates.length;
      candidateHues[c] = spot;
      index++;
    });

    core.Func1<MapPlayer, num> mapper = (c) => candidateHues[c];

    final mapElection = new DistanceElection(voters, candidates);
    var distanceView = new DistanceView(distanceDiv, mapElection, mapper);

    var pluralityElection = new PluralityElection(mapElection.ballots);
    var pluralityView = new PluralityView(pluralityDiv, pluralityElection, mapper);

    var condorcetElection = new CondorcetElection(mapElection.ballots);
    var condorcetView = new CondorcetView(condorcetDiv, condorcetElection, mapper);

    return new VoteDemo._internal(canvas, stage, voterMap,
      mapElection, candidateHues, condorcetView, pluralityView, distanceView);
  }

  VoteDemo._internal(
    this._canvas,
    this._stage,
    this._voterMap,
    this._mapElection,
    this._candidateHues,
    this._condorcetView,
    this._pluralityView,
    this._distanceView) :
      _playerHues = new HashMap<MapPlayer, num>() {
    _canvas.on.mouseMove.add(_canvas_mouseMove);
    _canvas.on.mouseOut.add(_canvas_mouseOut);

    _voterMap.voters = core.$(_mapElection.ballots).select((b) => b.voter).toList();
    _voterMap.candidates = _mapElection.candidates;
    _voterMap.candidateColorMapper = _getHue;
  }

  void requestFrame(){
    if(!_frameRequested) {
      _frameRequested = true;
      window.webkitRequestAnimationFrame(_onFrame);
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
    _mouse = value;
    final hits = Mouse.markMouseOver(_stage, _mouse);
    print(hits);
    requestFrame();
  }

  num _getHue(MapPlayer player) {
    return _playerHues.putIfAbsent(player, (){
      var color = _candidateHues[player];
      if(color == null) {
        final ballot = _mapElection.ballots
            .first((b) => b.voter == player);
        return _candidateHues[ballot.rank[0]];
      } else {
        return color;
      }
    });
  }
}
