part of vote.html;

class PluralityView extends HtmlView {
  PluralityElection _election;

  PluralityView(DivElement node) : super(node);

  PluralityElection get election => _election;

  void set election(PluralityElection election) {
    _election = election;
    markDirty();
  }

  void updateElement() {
    node.children.clear();

    var table = new TableElement();

    TableRowElement row = table.insertRow(-1);
    TableCellElement cell = new Element.tag('th');
    row.children.add(cell);
    cell.innerHtml = "Place";

    cell = new Element.tag('th');
    row.children.add(cell);
    cell.innerHtml = "Candidate";

    cell = new Element.tag('th');
    row.children.add(cell);
    row.classes.add('row-odd');
    cell.innerHtml = "Votes";

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
            cell = row.insertCell(-1);
            cell.rowSpan = place.length;
            cell.innerHtml = place.voteCount.toString();
            cell.classes.add('vote-count');

            first = false;
          }

          evenCandidateRow = !evenCandidateRow;
        }
        evenPlaceRow = !evenPlaceRow;
      }
    }

    node.children.add(table);
  }
}
