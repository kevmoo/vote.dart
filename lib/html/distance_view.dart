class DistanceView extends ElectionView {
  core.Func1<MapPlayer, num> _mapper;
  DistanceElection<MapPlayer, MapPlayer> _election;

  DistanceView(DivElement node) : super(node) {
    _mapper = (c) => 0;
  }

  void setCandidateColorMap(core.Func1<MapPlayer, num> value) {
    assert(value != null);
    _mapper = value;
    markDirty();
  }

  void set election(DistanceElection<MapPlayer, MapPlayer> value) {
    _election = value;
    markDirty();
  }

  void _updateElement() {
    _node.elements.clear();

    var table = new TableElement();
    TableRowElement row = table.insertRow(-1);
    row.classes.add('row-odd');
    TableCellElement cell = new Element.tag('th');
    row.elements.add(cell);
    cell.innerHTML = "Place";

    cell = new Element.tag('th');
    row.elements.add(cell);
    cell.innerHTML = "Candidate";

    cell = new Element.tag('th');
    row.elements.add(cell);
    cell.innerHTML = "Avg Dist";

    cell = new Element.tag('th');
    row.elements.add(cell);
    cell.innerHTML = "Avg Dist\u00B2";

    var evenPlaceRow = true;
    var evenCandidateRow = true;

    if(_election != null) {
      for(final place in _election.places) {
        var first = true;
        for(final candidate in place) {

          row = table.insertRow(-1);
          row.classes.add(evenPlaceRow ? 'row-even' : 'row-odd');

          if(first) {
            cell = new Element.tag('th');
            row.elements.add(cell);
            cell.classes.add('place-number');
            cell.rowSpan = place.length;
            cell.innerHTML = place.place.toString();
          }

          cell = row.insertCell(-1);
          cell.classes.add('candidate-cell');
          final hue = _mapper(candidate);
          if(hue != null) {
            final hsl = new core.HslColor(hue, 1, 0.75);
            final rgb = hsl.toRgb();
            cell.style.background = rgb.toHex();
          }
          cell.innerHTML = candidate.toString();


          if(first) {
            first = false;

            cell = row.insertCell(-1);
            cell.rowSpan = place.length;
            cell.innerHTML = place.avgDistance.toStringAsFixed(2);
            cell.classes.add('vote-count');

            cell = row.insertCell(-1);
            cell.rowSpan = place.length;
            cell.innerHTML = place.avgDistanceSquared.toStringAsFixed(2);
            cell.classes.add('vote-count');
          }

          evenCandidateRow = !evenCandidateRow;
        }
        evenPlaceRow = !evenPlaceRow;
      }

    }

    _node.elements.add(table);
  }
}
