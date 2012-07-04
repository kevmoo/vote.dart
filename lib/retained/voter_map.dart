class VoterMap extends PElement {
  core.Coordinate _mouse;
  final HashSet<MapPlayer> _players;

  VoterMap(int w, int h) :
    _players = new HashSet<MapPlayer>(),
    super(w, h);

  core.Coordinate get mouse(){
    return _mouse;
  }

  void set mouse(core.Coordinate value){
    _mouse = value;
  }

  Iterable<MapPlayer> get players() => _players;

  void set players(Iterable<MapPlayer> value) {
    core.requireArgumentNotNull(value, "value");
    _players.clear();
    _players.addAll(value);
    invalidateDraw();
  }

  void drawOverride(CanvasRenderingContext2D ctx){
    ctx.fillStyle = 'red';
    final scale = 30;
    var margin = 3;

    for(final player in _players) {
      final x = player.location.x;
      final y = player.location.y;
      CanvasUtil.ellipse(ctx, x * scale + margin, y * scale + margin, scale - 2 * margin, scale - 2 * margin);
      ctx.fill();
    }

    ctx.fillStyle = 'blue';
    if(_mouse != null){
      CanvasUtil.ellipse(ctx, _mouse.x - scale/2, _mouse.y - scale/2, scale - 2 * margin, scale - 2 * margin);
      ctx.fill();
    }
  }
}
