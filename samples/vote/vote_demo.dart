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
  var demo = new VoteDemo(canvas, pluralityDiv);
  demo.requestFrame();
}

class VoteDemo{
  final CanvasElement _canvas;
  final Stage _stage;
  final VoterMap _voterMap;
  final HashSet<MapPlayer> _voters;
  final HashSet<MapPlayer> _candidates;
  final HashMap<MapPlayer, num> _candidateHues;

  final PluralityElection _pluralityElection;
  final PluralityView _pluralityView;

  bool _frameRequested = false;

  factory VoteDemo(CanvasElement canvas, DivElement pluralityDiv) {
    var voterMap = new VoterMap(canvas.width, canvas.height);

    final span = 20;
    final spanTweak = span / (span - 1);

    // 100 voters from 1,1 to 10,10
    final voters = new List<MapPlayer>();
    for(var i = 0; i < span; i++) {
      for(var j = 0; j < span; j++) {
        voters.add(new MapPlayer(new core.Coordinate(i * spanTweak, j * spanTweak)));
      }
    }

    print(Clock.now() % 1000);
    final blah = Clock.now() % 1000;
    for(int i = 0; i < blah; i++) {
      Math.random();
    }

    final candidates = new List<MapPlayer>();

    for(var i = 0; i < 6; i++) {
      candidates.add(new MapPlayer(
        new core.Coordinate(Math.random() * span, Math.random() * span)));
    }

    var ballots = MapElection.createBallots(voters, candidates);

    var pe = new PluralityElection(ballots);

    //
    // Create the stage, etc
    //

    final stage = new Stage(canvas, voterMap);

    var pv = new PluralityView(pluralityDiv);
    pv.election = pe;

    return new VoteDemo._internal(canvas, stage, voterMap, pv, pe,
      voters, candidates);
  }

  VoteDemo._internal(this._canvas, this._stage, this._voterMap,
    this._pluralityView, this._pluralityElection, voters, candidates) :
    this._voters = new HashSet<MapPlayer>.from(voters),
    this._candidates = new HashSet<MapPlayer>.from(candidates),
    this._candidateHues = new HashMap<MapPlayer, num>() {
    _canvas.on.mouseMove.add(_canvas_mouseMove);
    _canvas.on.mouseOut.add(_canvas_mouseOut);

    var index = 0;
    _candidates.forEach((c) {
      final spot = 360 * index / _candidates.length;
      _candidateHues[c] = spot;
      index++;
    });

    _pluralityView.setCandidateColorMap( (c) => _candidateHues[c]);

    var allPlayers = new List<MapPlayer>();
    allPlayers.addAll(_voters);
    allPlayers.addAll(_candidates);

    _voterMap.players = allPlayers;
    _voterMap.drawer = _drawVoter;
  }

  void requestFrame(){
    if(!_frameRequested) {
      _frameRequested = true;
      window.webkitRequestAnimationFrame(_onFrame);
    }
  }

  bool _onFrame(num highResTime){
    _stage.draw();
    _frameRequested = false;
  }

  void _canvas_mouseMove(MouseEvent e){
    _voterMap.mouse = new core.Coordinate(e.offsetX, e.offsetY);
    requestFrame();
  }

  void _canvas_mouseOut(MouseEvent e){
    _voterMap.mouse = null;
    requestFrame();
  }

  void _drawVoter(CanvasRenderingContext2D ctx, MapPlayer player,
                         num radius) {
    if(_candidates.contains(player)) {
      final hue = _candidateHues[player];
      final rgb = (new core.HslColor(hue, 1, 0.5)).toRgb();
      ctx.fillStyle = rgb.toHex();
    }
    else {
      ctx.fillStyle = '#cccccc';
    }

    final x = player.location.x;
    final y = player.location.y;
    CanvasUtil.centeredCircle(ctx, x, y, radius);
    ctx.fill();
  }
}
