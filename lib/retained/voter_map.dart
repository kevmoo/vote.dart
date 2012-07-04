class VoterMap extends PElement {
  static final num _count = 10;
  core.Coordinate _mouse;
  final HashSet<MapPlayer> _points;

  VoterMap(int w, int h) :
    _points = new HashSet<MapPlayer>(),
    super(w, h);

  core.Coordinate get mouse(){
    return _mouse;
  }

  void set mouse(core.Coordinate value){
    _mouse = value;
  }

  void drawOverride(CanvasRenderingContext2D ctx){
    ctx.fillStyle = 'red';
    var w = width / _count;
    var h = height / _count;
    var margin = 3;

    for(var x = 0; x < _count; x++){
      for(var y = 0; y < _count; y++){
        CanvasUtil.ellipse(ctx, x * w + margin, y * h + margin, w - 2 * margin, h - 2 * margin);
        ctx.fill();
      }
    }

    ctx.fillStyle = 'blue';
    if(_mouse != null){
      CanvasUtil.ellipse(ctx, _mouse.x - w/2, _mouse.y - h/2, w - 2 * margin, h - 2 * margin);
      ctx.fill();
    }

  }
}
