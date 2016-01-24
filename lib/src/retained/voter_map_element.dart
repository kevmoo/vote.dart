import 'dart:html';

import 'package:bot/bot.dart' hide ReadOnlyCollection;
import 'package:bot_web/bot_html.dart';
import 'package:bot_web/bot_retained.dart';
import 'package:vote/map.dart';

import 'map_element_base.dart';

class VoterMapElement extends Thing implements MapElementBase {
  final List<MapPlayer> _players = new List<MapPlayer>();
  final AffineTransform _tx = new AffineTransform();

  num radius;
  Map<MapPlayer, String> _map = new Map<MapPlayer, String>();

  VoterMapElement(int w, int h) : super(w, h) {
    cacheEnabled = true;
    radius = 0.3;
  }

  void setTransform(AffineTransform value) {
    requireArgumentNotNull(value, 'value');
    _tx.setFromTransfrom(value);
    invalidateDraw();
  }

  Iterable<MapPlayer> get players => _players;

  void set players(Iterable<MapPlayer> value) {
    requireArgumentNotNull(value, "value");
    _players.clear();
    _players.addAll(value);
    invalidateDraw();
  }

  void set playerHexMap(Map<MapPlayer, String> value) {
    assert(value != null);
    _map = value;
    invalidateDraw();
  }

  void drawOverride(CanvasRenderingContext2D ctx) {
    for (final player in _players) {
      _drawPlayer(ctx, player);
    }
  }

  void _drawPlayer(CanvasRenderingContext2D ctx, MapPlayer player) {
    String hex = _map[player];

    hex = hex == null ? '#999999' : hex;

    ctx.fillStyle = hex;
    final txLoc = _tx.transformCoordinate(player.location);

    CanvasUtil.centeredCircle(ctx, txLoc.x, txLoc.y, radius * _tx.scaleX);
    ctx.fill();
  }
}
