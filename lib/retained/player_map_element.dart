class PlayerMapElement extends PElement {
  final List<MapPlayer> _players;
  final core.AffineTransform _tx;

  num _radius;
  HashMap<MapPlayer, num> _map;

  PlayerMapElement(int w, int h) :
    _tx = new core.AffineTransform(),
    _players = new List<MapPlayer>(),
    super(w, h, true) {
    _radius = 0.3;
    _map = new HashMap<MapPlayer, num>();
  }

  void setTransform(core.AffineTransform value) {
    core.requireArgumentNotNull(value, 'value');
    _tx.setFromTransfrom(value);
    invalidateDraw();
  }

  Iterable<MapPlayer> get players() => _players;

  void set players(Collection<MapPlayer> value) {
    core.requireArgumentNotNull(value, "value");
    _players.clear();
    _players.addAll(value);
    invalidateDraw();
  }

  void set playerHueMap(HashMap<MapPlayer, num> value) {
    assert(value != null);
    _map = value;
    invalidateDraw();
  }

  void drawOverride(CanvasRenderingContext2D ctx){
    for(final player in _players) {
      _drawPlayer(ctx, player);
    }
  }

  void _drawPlayer(CanvasRenderingContext2D ctx, MapPlayer player) {

    final hue = _map[player];
    final rgb = hue == null ?
        new core.RgbColor(204,204,204) :
        (new core.HslColor(hue, 0.5, 0.75)).toRgb();

    ctx.fillStyle = rgb.toHex();
    final txLoc = _tx.transformCoordinate(player.location);

    CanvasUtil.centeredCircle(ctx, txLoc.x, txLoc.y, _radius * _tx.scaleX);
    ctx.fill();
  }
}
