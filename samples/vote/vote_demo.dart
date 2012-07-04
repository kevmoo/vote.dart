#import('dart:html');
#import('../../../dartlib/lib/core.dart', prefix:'core');
#import('../../../dartlib/lib/retained.dart');
#import('../../lib/vote.dart');
#import('../../lib/map.dart');
#import('../../lib/retained.dart');

main(){
  CanvasElement canvas = document.query("#content");
  var demo = new VoteDemo(canvas);
  demo.requestFrame();
}

class VoteDemo{
  final CanvasElement _canvas;
  final Stage _stage;
  final VoterMap _voterMap;

  factory VoteDemo(CanvasElement canvas){
    var voterMap = new VoterMap(canvas.width, canvas.height);

    //
    // Populate
    //
    // 11 voters from 0,0 to 10,0
    var voters = new List<MapPlayer>();
    for(var i = 0; i <= 10; i++) {
      voters.add(new MapPlayer(new core.Coordinate(i,0)));
    }

    voterMap.players = voters;

    // center at 5
    //var canCenter = new MapPlayer(const core.Coordinate(5, 0));

    // left at 4
    //var canLeft = new MapPlayer(const core.Coordinate(4, 0));

    // spoiler at 7
    //var canSpoiler = new MapPlayer(const core.Coordinate(7, 0));


    //
    // Create the stage, etc
    //

    var stage = new Stage(canvas, voterMap);

    return new VoteDemo._internal(canvas, stage, voterMap);
  }

  VoteDemo._internal(this._canvas, this._stage, this._voterMap){
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
