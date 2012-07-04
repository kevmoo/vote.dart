class VoterMap extends PElement {
  core.Coordinate _mouse;
  final HashSet<MapPlayer> _players;
  num _averageCloseness;
  core.Rect _bounds;

  num _txX, _txY, _txScale, _radius;

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
    final vals = _getAverageCloseness(value);
    _averageCloseness = vals.Item1;
    assert(core.isValidNumber(_averageCloseness));
    _bounds = vals.Item2;
    assert(_bounds.isValid);

    _txX = _txY = _txScale = _radius = null;
    invalidateDraw();
  }

  void drawOverride(CanvasRenderingContext2D ctx){
    // Draw in a background
    ctx.fillStyle = '#999999';
    ctx.fillRect(0, 0, width, height);

    // calculate important bits if we need to
    if(_txX == null) {
      [_txX, _txY, _txScale, _radius].every((v) => !core.isValidNumber(v));

      // dimensions of the points factoring in the radius
      final dataScale = new core.Size(_bounds.width + _averageCloseness,
        _bounds.height + _averageCloseness);

      // now are we bound by width or height?
      if(dataScale.aspectRatio > size.aspectRatio) {
        // bound by width
        _txScale = width / dataScale.width;
      }
      else {
        _txScale = height / dataScale.height;
      }

      // TODO: center the output, but this is pretty good for now
      _txX = _bounds.left + _averageCloseness / 2;
      _txY = _bounds.top + _averageCloseness / 2;

      // radius is used to space items.
      // should be less than half of the average Closeness
      _radius = _averageCloseness * 0.4;
    }
    assert([_txX, _txY, _txScale, _radius].every(core.isValidNumber));

    // start our transform and draw
    ctx.save();

    ctx.scale(_txScale, _txScale);
    ctx.translate(_txX, _txY);

    ctx.fillStyle = 'red';

    for(final player in _players) {
      final x = player.location.x;
      final y = player.location.y;
      CanvasUtil.centeredCircle(ctx, x, y, _radius);

      ctx.fill();
    }

    ctx.restore();

    if(_mouse != null){
      ctx.fillStyle = 'blue';
      CanvasUtil.centeredCircle(ctx, _mouse.x, _mouse.y, _txScale / 2);
      ctx.fill();
    }

  }

  // For each player
  // 1) find the closest guy [>= 0.5 away to avoid overlapping]
  // 2) find the average of the closest guys
  static core.Tuple<num, core.Rect> _getAverageCloseness(Iterable<MapPlayer> players) {
    num top = double.INFINITY;
    num left = double.INFINITY;
    num bottom = double.NEGATIVE_INFINITY;
    num right = double.NEGATIVE_INFINITY;

    int count = 0;
    num sum = 0;
    for(final playerA in players) {
      num closestDistance = null;

      left = Math.min(playerA.location.x, left);
      top = Math.min(playerA.location.y, top);
      right = Math.max(playerA.location.x, right);
      bottom = Math.max(playerA.location.y, bottom);

      for (final playerB in players) {
        if(playerA != playerB) {
          final distance = playerA.location.getDistance(playerB.location);
          if(distance >= 0.5 && (closestDistance == null || distance < closestDistance)) {
            closestDistance = distance;
          }
        }
      }
      if(closestDistance != null) {
        assert(closestDistance >= 0.5);
        sum += closestDistance;
        count++;
      }
    }

    final avgDist = count == null ? null : sum / count;

    return new core.Tuple<num, core.Rect>(avgDist,
        new core.Rect(left, top, right, bottom));
  }
}
