import 'dart:ui';

// RGB-HSL conversion logic borrowed with love from Google Closure Library
// http://code.google.com/p/closure-library/source/browse/trunk/closure/goog/color/color.js

class HslColor {
  final double h, s, l;

  const HslColor._internal(this.h, this.s, this.l);

  factory HslColor(double h, double s, double l) =>
      HslColor._internal(h % 360, s, l);

  Color toColor() {
    final normH = h / 360; // normalize h to fall in [0, 1]

    double r, g, b;

    if (s == 0) {
      r = g = b = l * 255;
    } else {
      final temp2 = (l < 0.5) ? l * (1 + s) : l + s - (s * l);
      final temp1 = 2 * l - temp2;
      r = 255 * _hueToRgb(temp1, temp2, normH + (1 / 3));
      g = 255 * _hueToRgb(temp1, temp2, normH);
      b = 255 * _hueToRgb(temp1, temp2, normH - (1 / 3));
    }

    return Color.fromRGBO(r.round(), g.round(), b.round(), 1);
  }

  @override
  int get hashCode => h.hashCode ^ s.hashCode ^ l.hashCode;

  @override
  bool operator ==(other) =>
      other is HslColor && other.h == h && other.s == s && other.l == l;

  @override
  String toString() => '{HslColor: $h, $s, $l}';

  static double _hueToRgb(double v1, double v2, num vH) {
    vH %= 1.0;

    if ((6 * vH) < 1) {
      return v1 + (v2 - v1) * 6 * vH;
    } else if (2 * vH < 1) {
      return v2;
    } else if (3 * vH < 2) {
      return v1 + (v2 - v1) * ((2 / 3) - vH) * 6;
    }
    return v1;
  }
}
