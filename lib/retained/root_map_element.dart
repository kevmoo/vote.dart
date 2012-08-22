class RootMapElement extends ElementParentImpl {
  final VoterMapElement _voterMap;
  final CandidateMapElement _candidateMap;
  final core.AffineTransform _tx;
  final core.EventHandle<core.EventArgs> _candidatesMovedHandle;

  num _averageCloseness;
  core.Rect _bounds;
  num _radius;

  RootMapElement(int w, int h) :
    _tx = new core.AffineTransform(),
    _voterMap = new VoterMapElement(w, h),
    _candidateMap = new CandidateMapElement(w, h),
    _candidatesMovedHandle = new core.EventHandle<core.EventArgs>(),
    super(w, h) {
    _voterMap.registerParent(this);
    _candidateMap.registerParent(this);
  }

  core.EventRoot<core.EventArgs> get candidatesMoved =>
     _candidatesMovedHandle;

  int get visualChildCount => 2;

  PElement getVisualChild(int index){
    switch(index) {
      case 0:
        return _voterMap;
      case 1:
        return _candidateMap;
      default:
        throw 'bad index, foo!';
    }
  }

  void set locationData(LocationData data) {
    voters = data.voters;
    candidates = data.candidates;
    invalidateDraw();
  }

  Iterable<MapPlayer> get voters => _voterMap.players;

  void set voterHexMap(HashMap<MapPlayer, String> value) {
    _voterMap.playerHexMap = value;
  }

  void set voters(Collection<MapPlayer> value) {
    core.requireArgumentNotNull(value, "value");
    // TODO: would be great to use this calculation, but need to make it async
    //final vals = _getAverageCloseness(value);
    final vals = new core.Tuple<num, core.Rect>(1, new core.Rect(0,0,20,20));

    _averageCloseness = vals.Item1;
    assert(core.isValidNumber(_averageCloseness));
    _bounds = vals.Item2;
    assert(_bounds.isValid);

    _radius = null;
    _voterMap.players = value;
  }

  void set candidates(Collection<MapPlayer> value) {
    core.requireArgumentNotNull(value, "value");
    _candidateMap.players = value;
  }

  Collection<MapPlayer> get showOnlyPlayers => _candidateMap.showOnlyPlayers;

  void set showOnlyPlayers(Iterable<MapPlayer> value) {
    _candidateMap.showOnlyPlayers = value;
  }

  void dragCandidate(MapPlayer candidate, core.Vector delta) {
    final can = core.$(_candidateMap.players).single((mp) => mp == candidate);

    final candidateLocPixels = _tx.transformCoordinate(candidate.location);
    final newCanLocPix = candidateLocPixels + delta;
    var newLocation = _tx.createInverse().transformCoordinate(newCanLocPix);
    newLocation = LocationData.bounds.constrain(newLocation);

    can.location = newLocation;

    _candidatesMovedHandle.fireEvent(core.EventArgs.empty);
  }

  void update(){
    // calculate important bits if we need to
    if(_bounds != null && _radius == null) {

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
      _radius = _averageCloseness * 0.3;
    }

    [_voterMap, _candidateMap].forEach((m) {
      m._radius = _radius;
      m.setTransform(_tx);
    });

    super.update();
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

      left = math.min(playerA.location.x, left);
      top = math.min(playerA.location.y, top);
      right = math.max(playerA.location.x, right);
      bottom = math.max(playerA.location.y, bottom);

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
