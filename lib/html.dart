library vote.html;

import 'dart:async';
import 'dart:html' hide Player;
import 'dart:math' as math;
import 'package:bot/bot.dart' hide ReadOnlyCollection;
import 'package:bot_web/bot_html.dart';
import 'map.dart';
import 'vote.dart';
import 'src/util.dart';

part 'src/html/candidate_manager_view.dart';
part 'src/html/plurality_view.dart';
part 'src/html/distance_view.dart';
part 'src/html/condorcet_view.dart';
part 'src/html/irv_view.dart';

const String _grayHex = '#999999';

String getCandidateHexColor(c, [bool dark = false]) {
  final hue = LocationData.getHue(c);
  if (hue == null) {
    return _grayHex;
  } else {
    final hsl = new HslColor(hue, 1, dark ? 0.3 : 0.75);
    return hsl.toRgb().toHex();
  }
}
