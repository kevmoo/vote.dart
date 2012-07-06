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

  final PluralityElection _pluralityElection;
  final PluralityView _pluralityView;

  factory VoteDemo(CanvasElement canvas, DivElement pluralityDiv) {
    var voterMap = new VoterMap(canvas.width, canvas.height);

    // 100 voters from 1,1 to 10,10
    final voters = new List<MapPlayer>();
    for(var i = 0; i < 10; i++) {
      for(var j = 0; j < 10; j++) {
        voters.add(new MapPlayer(new core.Coordinate(i, j)));
      }
    }

    final candidates = new List<MapPlayer>();

    // center
    candidates.add(new MapPlayer(const core.Coordinate(4.5, 4.5)));

    // left at 4
    candidates.add(new MapPlayer(const core.Coordinate(2.5, 3.5)));

    // spoiler at 7
    candidates.add(new MapPlayer(const core.Coordinate(7.5, 5.5)));

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
    this._candidates = new HashSet<MapPlayer>.from(candidates) {
    _canvas.on.mouseMove.add(_canvas_mouseMove);
    _canvas.on.mouseOut.add(_canvas_mouseOut);

    var allPlayers = new List<MapPlayer>();
    allPlayers.addAll(_voters);
    allPlayers.addAll(_candidates);

    _voterMap.players = allPlayers;
    _voterMap.drawer = _drawVoter;
  }

  void requestFrame(){
    window.webkitRequestAnimationFrame(_onFrame);
  }

  bool _onFrame(num highResTime){
    _stage.draw();
    requestFrame();
  }

  void _canvas_mouseMove(MouseEvent e){
    _voterMap.mouse = new core.Coordinate(e.offsetX, e.offsetY);
  }

  void _canvas_mouseOut(MouseEvent e){
    _voterMap.mouse = null;
  }

  void _drawVoter(CanvasRenderingContext2D ctx, MapPlayer player,
                         num radius) {
    if(_candidates.contains(player)) {
      ctx.fillStyle = 'green';
    }
    else {
      ctx.fillStyle = '#999999';
    }

    final x = player.location.x;
    final y = player.location.y;
    CanvasUtil.centeredCircle(ctx, x, y, radius);
    ctx.fill();
  }
}
