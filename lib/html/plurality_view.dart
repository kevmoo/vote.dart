class PluralityView {
  final DivElement _node;
  PluralityElection _election;
  core.Func1<MapPlayer, core.RgbColor> _mapper;

  PluralityView(this._node) {
    _updateElement();
  }

  PluralityElection get election() => _election;

  void set election(PluralityElection election) {
    _election = election;
    _updateElement();
  }

  void setCandidateColorMap(core.Func1<MapPlayer, core.RgbColor> value) {
    _mapper = value;
    _updateElement();
  }

  // some element to hold onto

  // void updateElection(PluralityElection election)

  void _updateElement() {
    _node.elements.clear();

    var table = new TableElement();
    TableRowElement row = table.insertRow(-1);
    TableCellElement cell = new Element.tag('th');
    row.elements.add(cell);
    cell.colSpan = 3;
    cell.innerHTML = "Plurality";

    row = table.insertRow(-1);
    cell = new Element.tag('th');
    row.elements.add(cell);
    cell.innerHTML = "Place";

    cell = new Element.tag('th');
    row.elements.add(cell);
    cell.innerHTML = "Candidate";

    cell = new Element.tag('th');
    row.elements.add(cell);
    row.classes.add('place-row-odd');
    cell.innerHTML = "Votes";

    var evenPlaceRow = true;
    var evenCandidateRow = true;

    if(_election != null) {
      for(final place in _election.places) {
        var first = true;
        for(final candidate in place) {

          row = table.insertRow(-1);
          row.classes.add(evenPlaceRow ? 'place-row-even' : 'place-row-odd');
          row.classes.add(evenCandidateRow ? 'candidate-row-even' : 'candidate-row-odd');

          if(first) {
            cell = new Element.tag('th');
            row.elements.add(cell);
            cell.classes.add('rank-number');
            cell.rowSpan = place.length;
            cell.innerHTML = place.place.toString();
          }

          cell = row.insertCell(-1);
          cell.classes.add('candidate-cell');
          if(_mapper != null) {
            var rgb = _mapper(candidate);
            if(rgb != null) {
              var hsl = rgb.toHsl();
              final newL = 0.5 + hsl.l / 2;
              final newS = 0.5 * hsl.s;
              rgb = (new core.HslColor(hsl.h, newS, newL)).toRgb();
              cell.style.background = rgb.toHex();
            }
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