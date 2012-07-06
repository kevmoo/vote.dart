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

  final PluralityElection _pluralityElection;
  final PluralityView _pluralityView;

  factory VoteDemo(CanvasElement canvas, DivElement pluralityDiv) {
    var voterMap = new VoterMap(canvas.width, canvas.height);

    //
    // Populate
    //
    var voters = new List<MapPlayer>();
    for(var i = 0; i < 10; i++) {
      for(var j = 0; j < 10; j++) {
        voters.add(new MapPlayer(new core.Coordinate(i,j)));
      }
    }

    voterMap.players = voters;

    // center
    var canCenter = new MapPlayer(const core.Coordinate(3.5, 5));

    // left
    var canLeft = new MapPlayer(const core.Coordinate(5.5, 5));

    // spoiler at 7
    var canSpoiler = new MapPlayer(const core.Coordinate(4.5, 0));

    var ballots = MapElection.createBallots(voters, [canCenter, canLeft, canSpoiler]);

    var pe = new PluralityElection(ballots);

    //
    // Create the stage, etc
    //

    var stage = new Stage(canvas, voterMap);

    var pv = new PluralityView(pluralityDiv);
    pv.election = pe;

    return new VoteDemo._internal(canvas, stage, voterMap, pv, pe);
  }

  VoteDemo._internal(this._canvas, this._stage, this._voterMap,
    this._pluralityView, this._pluralityElection){
    _canvas.on.mouseMove.add(_canvas_mouseMove);
    _canvas.on.mouseOut.add(_canvas_mouseOut);
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
}
