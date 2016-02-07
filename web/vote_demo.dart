import 'dart:html';

import 'package:vote/vote.dart';

void main() {
  CanvasElement canvas = querySelector("#content");
  DivElement pluralityDiv = querySelector('#pluralityView');
  DivElement distanceDiv = querySelector('#distanceView');
  DivElement condorcetDiv = querySelector('#condorcetView');
  DivElement canManDiv = querySelector('#canManView');
  DivElement irvDiv = querySelector('#irvView');
  var demo = new VoteDemo(
      canvas, pluralityDiv, distanceDiv, condorcetDiv, canManDiv, irvDiv);
  demo.requestFrame();
}
