#import('dart:html');
#import('../../src/_dartlib.dart');
#source('VoterMap.dart');

main(){
  CanvasElement canvas = document.query("#content");
  var demo = new VoteDemo(canvas);
  demo.requestFrame();
}

class VoteDemo{
  final CanvasElement _canvas;
  final Stage _stage;
  final VoterMap _voterMap;

  Coordinate _mouseLocation;

  factory VoteDemo(CanvasElement canvas){
    var voterMap = new VoterMap(canvas.width, canvas.height);

    var stage = new Stage(canvas, voterMap);

    return new VoteDemo._internal(canvas, stage, voterMap);
  }

  VoteDemo._internal(CanvasElement this._canvas, Stage this._stage, VoterMap this._voterMap){
    _canvas.on.mouseMove.add(_canvas_mouseMove);
    _canvas.on.mouseOut.add(_canvas_mouseOut);
  }

  void requestFrame(){
    window.webkitRequestAnimationFrame(_onFrame);
  }

  bool _onFrame(num highResTime){
    _stage.draw();
    if(_mouseLocation != null){
      RetainedDebug.borderHitTest(_stage, _mouseLocation);
    }
    requestFrame();
  }

  void _canvas_mouseMove(MouseEvent e){
    _mouseLocation = new Coordinate(e.offsetX, e.offsetY);
  }

  void _canvas_mouseOut(MouseEvent e){
    _mouseLocation = null;
  }
}
