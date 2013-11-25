part of vote_retanied;

class RootMapElement extends ParentThing {
  final VoterMapElement _voterMap;
  final CandidateMapElement _candidateMap;
  final AffineTransform _tx = new AffineTransform();
  final EventHandle<EventArgs> _candidatesMovedHandle =
      new EventHandle<EventArgs>();

  num _averageCloseness;
  Box _bounds;
  num _radius;

  RootMapElement(int w, int h) :
    _voterMap = new VoterMapElement(w, h),
    _candidateMap = new CandidateMapElement(w, h),
    super(w, h) {
    _voterMap.registerParent(this);
    _candidateMap.registerParent(this);
  }

  Stream<EventArgs> get candidatesMoved =>
     _candidatesMovedHandle.stream;

  int get visualChildCount => 2;

  Thing getVisualChild(int index){
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

  void set voterHexMap(Map<MapPlayer, String> value) {
    _voterMap.playerHexMap = value;
  }

  void set voters(Iterable<MapPlayer> value) {
    requireArgumentNotNull(value, "value");
    // TODO: would be great to use this calculation, but need to make it async
    //final vals = _getAverageCloseness(value);
    final vals = new Tuple<num, Box>(1, new Box(0,0,LocationData.SPAN,LocationData.SPAN));

    _averageCloseness = vals.item1;
    assert(isValidNumber(_averageCloseness));
    _bounds = vals.item2;
    assert(_bounds.isValid);

    _radius = null;
    _voterMap.players = value;
  }

  void set candidates(Iterable<MapPlayer> value) {
    requireArgumentNotNull(value, "value");
    _candidateMap.players = value;
  }

  Sequence<MapPlayer> get showOnlyPlayers => _candidateMap.showOnlyPlayers;

  void set showOnlyPlayers(Iterable<MapPlayer> value) {
    _candidateMap.showOnlyPlayers = value;
  }

  void dragCandidate(MapPlayer candidate, Vector delta) {
    final can = _candidateMap.players.singleWhere((mp) => mp == candidate);

    final candidateLocPixels = _tx.transformCoordinate(candidate.location);
    final newCanLocPix = candidateLocPixels + delta;
    var newLocation = _tx.createInverse().transformCoordinate(newCanLocPix);
    newLocation = LocationData.BOUNDS.constrain(newLocation);

    can.location = newLocation;

    _candidatesMovedHandle.add(EventArgs.empty);
  }

  void update(){
    // calculate important bits if we need to
    if(_bounds != null && _radius == null) {

      // dimensions of the points factoring in the radius
      final dataScale = new Size(_bounds.width + _averageCloseness,
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
  static Tuple<num, Box> _getAverageCloseness(Iterable<MapPlayer> players) {
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
          final distance = playerA.location.distanceTo(playerB.location);
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

    return new Tuple<num, Box>(avgDist, new Box(left, top, right, bottom));
  }
}
