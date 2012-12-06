part of vote_retanied;

class VoterMapElement extends Thing implements MapElementBase {
  final List<MapPlayer> _players = new List<MapPlayer>();
  final AffineTransform _tx = new AffineTransform();

  num _radius;
  HashMap<MapPlayer, String> _map = new HashMap<MapPlayer, String>();

  VoterMapElement(int w, int h) : super(w, h, true) {
    _radius = 0.3;
  }

  void setTransform(AffineTransform value) {
    requireArgumentNotNull(value, 'value');
    _tx.setFromTransfrom(value);
    invalidateDraw();
  }

  Iterable<MapPlayer> get players => _players;

  void set players(Collection<MapPlayer> value) {
    requireArgumentNotNull(value, "value");
    _players.clear();
    _players.addAll(value);
    invalidateDraw();
  }

  void set playerHexMap(HashMap<MapPlayer, String> value) {
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
    String hex = _map[player];

    hex = hex == null ? '#999999' : hex;

    ctx.fillStyle = hex;
    final txLoc = _tx.transformCoordinate(player.location);

    CanvasUtil.centeredCircle(ctx, txLoc.x, txLoc.y, _radius * _tx.scaleX);
    ctx.fill();
  }
}
