import 'dart:async';
import 'dart:html';
import 'dart:math' as math;

import 'package:bot/bot.dart' hide ReadOnlyCollection;
import 'package:bot_web/bot_retained.dart';
import 'package:vote/map.dart';

import 'candidate_map_element.dart';
import 'map_element_base.dart';
import 'voter_map_element.dart';

class RootMapElement extends ParentThing {
  final VoterMapElement _voterMap;
  final CandidateMapElement _candidateMap;
  final AffineTransform _tx = new AffineTransform();
  final StreamController _candidatesMovedHandle = new StreamController();

  num _averageCloseness;
  Rectangle _bounds;
  num _radius;

  RootMapElement(int w, int h)
      : _voterMap = new VoterMapElement(w, h),
        _candidateMap = new CandidateMapElement(w, h),
        super(w, h) {
    _voterMap.registerParent(this);
    _candidateMap.registerParent(this);
  }

  Stream get candidatesMoved => _candidatesMovedHandle.stream;

  int get visualChildCount => 2;

  Thing getVisualChild(int index) {
    switch (index) {
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
    final vals = new Tuple<num, Rectangle>(
        1, new Rectangle(0, 0, LocationData.SPAN, LocationData.SPAN));

    _averageCloseness = vals.item1;
    assert(isValidNumber(_averageCloseness));
    _bounds = vals.item2;

    _radius = null;
    _voterMap.players = value;
  }

  void set candidates(Iterable<MapPlayer> value) {
    requireArgumentNotNull(value, "value");
    _candidateMap.players = value;
  }

  List<MapPlayer> get showOnlyPlayers => _candidateMap.showOnlyPlayers;

  void set showOnlyPlayers(Iterable<MapPlayer> value) {
    _candidateMap.showOnlyPlayers = value;
  }

  void dragCandidate(MapPlayer candidate, Vector delta) {
    final can = _candidateMap.players.singleWhere((mp) => mp == candidate);

    final candidateLocPixels = _tx.transformCoordinate(candidate.location);
    final newCanLocPix = candidateLocPixels + delta;
    var newLocation = _tx.createInverse().transformCoordinate(newCanLocPix);
    newLocation = _constrain(LocationData.BOUNDS, newLocation);

    can.location = newLocation;

    _candidatesMovedHandle.add(null);
  }

  void update() {
    // calculate important bits if we need to
    if (_bounds != null && _radius == null) {
      // dimensions of the points factoring in the radius
      final dataScale = new Size(_bounds.width + _averageCloseness,
          _bounds.height + _averageCloseness);

      num scale, offsetX = 0, offsetY = 0;
      // now are we bound by width or height?
      if (dataScale.aspectRatio > size.aspectRatio) {
        // bound by width
        scale = width / dataScale.width;

        final targetHeight = height / scale;
        offsetY = (targetHeight - dataScale.height) / 2;
      } else {
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

    <
        MapElementBase>[_voterMap, _candidateMap].forEach((MapElementBase m) {
      m.radius = _radius;
      m.setTransform(_tx);
    });

    super.update();
  }
}

Point _constrain(Rectangle rect, Point value) {
  requireArgumentNotNull(value, 'value');

  var x = math.min(rect.right, math.max(rect.left, value.x));
  var y = math.min(rect.bottom, math.max(rect.top, value.y));

  return new Coordinate(x, y);
}
