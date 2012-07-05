class VoterMap extends PElement {
  core.Coordinate _mouse;
  final HashSet<MapPlayer> _players;
  num _averageCloseness;
  core.Rect _bounds;

  num _radius;
  final core.AffineTransform _tx;

  VoterMap(int w, int h) :
    _players = new HashSet<MapPlayer>(),
    _tx = new core.AffineTransform(),
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

    _radius = null;
    invalidateDraw();
  }

  void drawOverride(CanvasRenderingContext2D ctx){
    // Draw in a background
    ctx.fillStyle = '#999999';
    ctx.fillRect(0, 0, width, height);

    // calculate important bits if we need to
    if(_radius == null) {

      // dimensions of the points factoring in the radius
      final dataScale = new core.Size(_bounds.width + _averageCloseness,
        _bounds.height + _averageCloseness);

      num scale, offsetX = 0, offsetY = 0;
      // now are we bound by width or height?
      if(dataScale.aspectRatio > size.aspectRatio) {
        // bound by width
        scale = width / dataScale.width;

        final targetHeight = height / scale;
        offsetY = (targetHeight - dataScale.height) / 2;
      }
      else {
        // bound by height
        scale = height / dataScale.height;

        final targetWidth = width / scale;
        offsetX = (targetWidth - dataScale.width) / 2;
      }
      _tx.setToScale(scale, scale);

      // Traslate the topLeft
      _tx.translate(_bounds.left + _averageCloseness / 2 + offsetX,
        _bounds.top + _averageCloseness / 2 + offsetY);

      // radius is used to space items.
      // should be less than half of the average Closeness
      _radius = _averageCloseness * 0.4;
    }
    assert(core.isValidNumber(_radius));

    // start our transform and draw
    ctx.save();

    CanvasUtil.transform(ctx, _tx);

    ctx.fillStyle = 'red';

    for(final player in _players) {
      final x = player.location.x;
      final y = player.location.y;
      CanvasUtil.centeredCircle(ctx, x, y, _radius);

      ctx.fill();
    }

    if(_mouse != null){
      ctx.fillStyle = 'blue';
      var mouseCoord = new core.Coordinate(_mouse.x, _mouse.y);
      mouseCoord = _tx.createInverse().transformCoordinate(mouseCoord);
      CanvasUtil.star(ctx, mouseCoord.x, mouseCoord.y, _radius);
      ctx.fill();
    }

    ctx.restore();
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
