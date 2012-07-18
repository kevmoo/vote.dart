class RootMapElement extends ElementParentImpl {
  final PlayerMapElement _voterMap;
  final CandidateMapElement _candidateMap;
  final core.AffineTransform _tx;
  final core.EventHandle<LocationData> _requestLocationUpdateHandle;

  num _averageCloseness;
  core.Rect _bounds;
  num _radius;

  RootMapElement(int w, int h) :
    _tx = new core.AffineTransform(),
    _voterMap = new PlayerMapElement(w, h),
    _candidateMap = new CandidateMapElement(w, h),
    _requestLocationUpdateHandle = new core.EventHandle<LocationData>(),
    super(w, h) {
    _voterMap.registerParent(this);
    _candidateMap.registerParent(this);
  }

  core.EventRoot<LocationData> get locationUpdateRequest() =>
      _requestLocationUpdateHandle;

  int get visualChildCount() => 2;

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
    candidateColorMapper = data.getHue;
    invalidateDraw();
  }

  Iterable<MapPlayer> get voters() => _voterMap.players;

  void set candidateColorMapper(core.Func1<MapPlayer, num> value) {
    _voterMap._mapper = _candidateMap._mapper = value;
  }

  void set voterHueMapper(core.Func1<MapPlayer, num> value) {
    _voterMap._mapper = value;
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

  void dragCandidate(MapPlayer candidate, core.Vector delta) {
    final candidateLocPixels = _tx.transformCoordinate(candidate.location);
    final newCanLocPix = candidateLocPixels + delta;

    final newLocation = _tx.createInverse().transformCoordinate(newCanLocPix);

    final roVoters = new core.ReadOnlyCollection(_voterMap.players);
    final candidates = new List<MapPlayer>.from(_candidateMap.players);

    final index = candidates.indexOf(candidate);

    candidate.location = newLocation;

    candidates[index] = candidate;

    final roCandidates = new core.ReadOnlyCollection.wrap(candidates);

    final randomData = new LocationData(roVoters, roCandidates);

    _requestLocationUpdateHandle.fireEvent(randomData);
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
