import 'dart:html';

import 'package:bot/bot.dart' hide ReadOnlyCollection;
import 'package:bot_web/bot_html.dart';

import '../map/distance_election.dart';
import '../map/location_data.dart';

class DistanceView extends HtmlView {
  DistanceElection _election;

  DistanceView(DivElement node) : super(node);

  void set election(DistanceElection value) {
    _election = value;
    markDirty();
  }

  @override
  void updateElement() {
    node.children.clear();

    var table = new TableElement();
    TableRowElement row = table.insertRow(-1);
    row.classes.add('row-odd');
    TableCellElement cell = new Element.tag('th');
    row.children.add(cell);
    cell.innerHtml = "Place";

    cell = new Element.tag('th');
    row.children.add(cell);
    cell.innerHtml = "Candidate";

    cell = new Element.tag('th');
    row.children.add(cell);
    cell.innerHtml = "Avg Dist";

    cell = new Element.tag('th');
    row.children.add(cell);
    cell.innerHtml = "Avg Dist\u00B2";

    var evenPlaceRow = true;
    var evenCandidateRow = true;

    if (_election != null) {
      for (final place in _election.places) {
        var first = true;
        for (final candidate in place) {
          row = table.insertRow(-1);
          row.classes.add(evenPlaceRow ? 'row-even' : 'row-odd');

          if (first) {
            cell = new Element.tag('th');
            row.children.add(cell);
            cell.classes.add('place-number');
            cell.rowSpan = place.length;
            cell.innerHtml = place.place.toString();
          }

          cell = row.insertCell(-1);
          cell.classes.add('candidate-cell');
          final hue = LocationData.getHue(candidate);
          if (hue != null) {
            final hsl = new HslColor(hue, 1, 0.75);
            final rgb = hsl.toRgb();
            cell.style.background = rgb.toHex();
          }
          cell.innerHtml = candidate.toString();

          if (first) {
            first = false;

            cell = row.insertCell(-1);
            cell.rowSpan = place.length;
            cell.innerHtml = place.avgDistance.toStringAsFixed(2);
            cell.classes.add('vote-count');

            cell = row.insertCell(-1);
            cell.rowSpan = place.length;
            cell.innerHtml = place.avgDistanceSquared.toStringAsFixed(2);
            cell.classes.add('vote-count');
          }

          evenCandidateRow = !evenCandidateRow;
        }
        evenPlaceRow = !evenPlaceRow;
      }
    }

    node.children.add(table);
  }
}
