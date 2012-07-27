class CondorcetView extends HtmlView {
  static final String _grayHex = '#999999';
  static final String _pairIdsKey = 'pair-ids';

  CondorcetElection _election;
  core.ReadOnlyCollection<Player> _candidates;

  CondorcetView(DivElement node) : super(node);

  CondorcetElection get election() => _election;

  void set election(CondorcetElection election) {
    _election = election;
    _candidates = null;
    markDirty();
  }

  void updateElement() {
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
      _candidates = _election.places.selectMany((p) => p).toReadOnlyCollection();

      final colors = _candidates.toHashMap((c) {
        final hue = LocationData.getHue(c);
        if(hue == null) {
          return _grayHex;
        } else {
          final hsl = new core.HslColor(hue, 1, 0.75);
          return hsl.toRgb().toHex();
        }
      });

      final darkColors = _candidates.toHashMap((c) {
        final hue = LocationData.getHue(c);
        if(hue == null) {
          return _grayHex;
        } else {
          final hsl = new core.HslColor(hue, 1, 0.3);
          return hsl.toRgb().toHex();
        }
      });

      for(final opp in _candidates) {
        cell = new Element.tag('th');
        row.elements.add(cell);
        cell.innerHTML = opp.toString();

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

          for(final opp in _candidates) {
            if(opp == candidate) {
              cell = row.insertCell(-1);
              cell.style.background = _grayHex;
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

              final cIndex = _candidates.indexOf(candidate);
              assert(cIndex >= 0);
              final oIndex = _candidates.indexOf(opp);
              assert(oIndex >= 0);

              final cellData = "${cIndex}_${oIndex}";

              cell = row.insertCell(-1);
              cell.innerHTML = pair.firstOverSecond.toString();
              cell.style.background = bg;
              cell.style.color = leftColor;
              cell.style.paddingRight = '0';
              cell.classes.add('vote-count');
              cell.dataAttributes[_pairIdsKey] = cellData;

              cell = row.insertCell(-1);
              cell.innerHTML = middleText;
              cell.style.background = bg;
              cell.style.color = fg;
              cell.dataAttributes[_pairIdsKey] = cellData;

              cell = row.insertCell(-1);
              cell.innerHTML = pair.secondOverFirst.toString();
              cell.style.background = bg;
              cell.style.color = rightColor;
              cell.style.paddingLeft = '0';
              cell.classes.add('vote-count');
              cell.dataAttributes[_pairIdsKey] = cellData;
            }
          }

          evenCandidateRow = !evenCandidateRow;
        }
        evenPlaceRow = !evenPlaceRow;
      }

    }

    table.on.mouseMove.add(_onMouseOver);
    table.on.mouseOut.add(_onMouseOut);

    _node.elements.add(table);
  }

  void _onMouseOver(MouseEvent e) {
    assert(_candidates != null);
    if(e.toElement is Element) {
      final Element elem = e.toElement;
      final String pairIdStr = elem.dataAttributes[_pairIdsKey];
      if(pairIdStr != null) {
        final idStrs = pairIdStr.split('_');
        assert(idStrs.length == 2);
        final ids = core.$(idStrs).select((s) => Math.parseInt(s)).toList();
        _hoverPair(ids[0], ids[1]);
        return;
      }
    }
    _hoverOff();
  }

  void _onMouseOut(args) {
    assert(_candidates != null);
    _hoverOff();
  }

  void _hoverPair(int index1, int index2) {
    // print(['hover', index1, index2]);
  }

  void _hoverOff() {
    // print('hover off');
  }
}
