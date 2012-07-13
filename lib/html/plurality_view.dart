class PluralityView {
  final DivElement _node;
  PluralityElection _election;
  core.Func1<MapPlayer, num> _mapper;

  PluralityView(this._node, this._election, this._mapper) {
    _updateElement();
  }

  PluralityElection get election() => _election;

  void set election(PluralityElection election) {
    _election = election;
    _updateElement();
  }

  void setCandidateColorMap(core.Func1<MapPlayer, num> value) {
    assert(value != null);
    _mapper = value;
    _updateElement();
  }

  void _updateElement() {
    _node.elements.clear();

    var table = new TableElement();

    TableRowElement row = table.insertRow(-1);
    TableCellElement cell = new Element.tag('th');
    row.elements.add(cell);
    cell.innerHTML = "Place";

    cell = new Element.tag('th');
    row.elements.add(cell);
    cell.innerHTML = "Candidate";

    cell = new Element.tag('th');
    row.elements.add(cell);
    row.classes.add('row-odd');
    cell.innerHTML = "Votes";

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
            cell = row.insertCell(-1);
            cell.rowSpan = place.length;
            cell.innerHTML = place.voteCount.toString();
            cell.classes.add('vote-count');

            first = false;
          }

          evenCandidateRow = !evenCandidateRow;
        }
        evenPlaceRow = !evenPlaceRow;
      }

    }

    _node.elements.add(table);

  }
}
