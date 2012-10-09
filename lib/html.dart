#library('vote_html');

#import('dart:html');
#import('dart:math', prefix:'math');
#import('package:bot/bot.dart');
#import('package:bot/html.dart');

#import('vote.dart');
#import('map.dart');

#source('html/candidate_manager_view.dart');
#source('html/plurality_view.dart');
#source('html/distance_view.dart');
#source('html/condorcet_view.dart');
#source('html/irv_view.dart');

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

