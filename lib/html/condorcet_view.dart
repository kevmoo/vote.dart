class CondorcetView extends ElectionView {
  CondorcetElection _election;
  core.Func1<MapPlayer, num> _mapper;

  CondorcetView(DivElement node, this._election, this._mapper) : super(node);

  CondorcetElection get election() => _election;

  void set election(CondorcetElection election) {
    _election = election;
    markDirty();
  }

  void setCandidateColorMap(core.Func1<MapPlayer, num> value) {
    assert(value != null);
    _mapper = value;
    markDirty();
  }

  void _updateElement() {
    _node.elements.clear();

    var table = new TableElement();

    TableRowElement row = table.insertRow(-1);
    TableCellElement cell = new Element.tag('th');
    row.elements.add(cell);
    row.classes.add('row-odd');
    cell.innerHTML = "Place";

    cell = new Element.tag('th');
    row.elements.add(cell);
    cell.innerHTML = "Candidate";

    if(_election != null) {
      var evenPlaceRow = true;
      var evenCandidateRow = true;

      // add columns for opponents
      var opps = _election.places.selectMany((p) => p).toReadOnlyCollection();

      final colors = opps.toHashMap((c) {
        final hue = _mapper(c);
        final hsl = new core.HslColor(hue, 1, 0.75);
        return hsl.toRgb().toHex();
      });

      final darkColors = opps.toHashMap((c) {
        final hue = _mapper(c);
        final hsl = new core.HslColor(hue, 1, 0.3);
        return hsl.toRgb().toHex();
      });

      for(final opp in opps) {
        cell = new Element.tag('th');
        row.elements.add(cell);
        cell.innerHTML = opp.name;

        cell.style.background = colors[opp];
        cell.colSpan = 3;
      }

      for(final place in _election.places) {
        bool first = true;
        for(final candidate in place) {

          row = table.insertRow(-1);
          row.classes.add(evenPlaceRow ? 'row-even' : 'row-odd');

          if(first) {
            first = false;
            cell = new Element.tag('th');
            row.elements.add(cell);
            cell.classes.add('place-number');
            cell.rowSpan = place.length;
            cell.innerHTML = place.place.toString();
          }

          cell = row.insertCell(-1);
          cell.classes.add('candidate-cell');

          cell.style.background = colors[candidate];
          cell.innerHTML = candidate.toString();

          for(final opp in opps) {
            if(opp == candidate) {
              cell = row.insertCell(-1);
              cell.style.background = '#999999';
              cell.colSpan = 3;
            } else {
              String middleText;
              String bg;
              String fg = 'black';
              String leftColor, rightColor;
              var pair = _election.getPair(candidate, opp);
              assert(pair != null);
              if(candidate == pair.winner) {
                bg = 'white';
                leftColor = darkColors[candidate];
                rightColor = darkColors[opp];
                middleText = '&gt;';
              } else if(opp == pair.winner) {
                bg = 'black';
                fg = 'white';
                leftColor = colors[candidate];
                rightColor = colors[opp];
                middleText = '&lt;';
              } else {
                assert(pair.isTie);
                bg = '#cccccc';
                leftColor = darkColors[candidate];
                rightColor = darkColors[opp];
                middleText = '=';
              }

              cell = row.insertCell(-1);
              cell.innerHTML = pair.firstOverSecond.toString();
              cell.style.background = bg;
              cell.style.color = leftColor;
              cell.style.paddingRight = '0';
              cell.classes.add('vote-count');

              cell = row.insertCell(-1);
              cell.innerHTML = middleText;
              cell.style.background = bg;
              cell.style.color = fg;

              cell = row.insertCell(-1);
              cell.innerHTML = pair.secondOverFirst.toString();
              cell.style.background = bg;
              cell.style.color = rightColor;
              cell.style.paddingLeft = '0';
              cell.classes.add('vote-count');
            }
          }

          evenCandidateRow = !evenCandidateRow;
        }
        evenPlaceRow = !evenPlaceRow;
      }

    }

    _node.elements.add(table);
  }
}
