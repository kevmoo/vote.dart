import 'package:bot/bot.dart' show HslColor;

import '../../map.dart';

const String grayHex = '#999999';

String getCandidateHexColor(c, [bool dark = false]) {
  final hue = LocationData.getHue(c);
  if (hue == null) {
    return grayHex;
  } else {
    final hsl = new HslColor(hue, 1, dark ? 0.3 : 0.75);
    return hsl.toRgb().toHex();
  }
}
