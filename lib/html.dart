library vote_html;

import 'dart:html';
import 'dart:math' as math;
import 'package:bot/bot.dart';
import 'package:bot/bot_html.dart';
import 'map.dart';
import 'vote.dart';

part 'html/candidate_manager_view.dart';
part 'html/plurality_view.dart';
part 'html/distance_view.dart';
part 'html/condorcet_view.dart';
part 'html/irv_view.dart';

const String _grayHex = '#999999';

String getCandidateHexColor(c, [bool dark = false]) {
  final hue = LocationData.getHue(c);
  if(hue == null) {
    return _grayHex;
  } else {
    final hsl = new HslColor(hue, 1, dark ? 0.3 : 0.75);
    return hsl.toRgb().toHex();
  }
}

