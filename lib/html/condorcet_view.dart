class CondorcetView extends HtmlView {
  static final String _grayHex = '#999999';
  static final String _pairIdsKey = 'pair-ids';

  CondorcetElection _election;
  core.ReadOnlyCollection<Player> _candidates;
  core.Tuple _hoveringPair;

  CondorcetView(DivElement node) : super(node);

  CondorcetElection get election() => _election;

  void set election(CondorcetElection election) {
    _election = election;
    _candidates = null;
    markDirty();
  }

  void updateElement() {
    node.elements.clear();

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
              String cellClass;
              String leftColor, rightColor;
              var pair = _election.getPair(candidate, opp);
              assert(pair != null);
              if(candidate == pair.winner) {
                cellClass = 'winner';
                leftColor = darkColors[candidate];
                rightColor = darkColors[opp];
                middleText = '&gt;';
              } else if(opp == pair.winner) {
                cellClass = 'loser';
                leftColor = colors[candidate];
                rightColor = colors[opp];
                middleText = '&lt;';
              } else {
                assert(pair.isTie);
                cellClass = 'tie';
                leftColor = darkColors[candidate];
                rightColor = darkColors[opp];
                middleText = '=';
              }

              final cellData = _getPairElementName(candidate, opp);

              cell = row.insertCell(-1);
              cell.innerHTML = pair.firstOverSecond.toString();
              cell.style.color = leftColor;
              cell.classes.add('vote-count');
              cell.classes.add('pair-cell');
              cell.classes.add(cellData);
              cell.classes.add(cellClass);
              cell.classes.add('left_value');
              cell.dataAttributes[_pairIdsKey] = cellData;

              cell = row.insertCell(-1);
              cell.innerHTML = middleText;
              cell.classes.add('pair-cell');
              cell.classes.add(cellClass);
              cell.classes.add(cellData);
              cell.dataAttributes[_pairIdsKey] = cellData;

              cell = row.insertCell(-1);
              cell.innerHTML = pair.secondOverFirst.toString();
              cell.style.color = rightColor;
              cell.classes.add('vote-count');
              cell.classes.add('right_value');
              cell.classes.add(cellClass);
              cell.classes.add('pair-cell');
              cell.classes.add(cellData);
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

    node.elements.add(table);
  }

  void set _thePair(core.Tuple pair) {
    assert(_candidates != null);
    if(pair != _hoveringPair) {
      _hoveringPair = pair;
      _updateCellHoverStyle();
    }
  }

  void _updateCellHoverStyle() {
    final String hoverPairClass = 'hover-pair';

    final List<Element> cells = node.queryAll('td.pair-cell.$hoverPairClass');
    cells.forEach((e){
      e.classes.remove(hoverPairClass);
    });

    if(_hoveringPair != null) {
      final matchClass =
          _getPairElementName(_hoveringPair.Item1, _hoveringPair.Item2);
      final List<Element> thePairs = node.queryAll('td.pair-cell.$matchClass');
      thePairs.forEach((e){
        e.classes.add(hoverPairClass);
      });
    }
  }

  void _onMouseOver(MouseEvent e) {
    assert(_candidates != null);
    if(e.toElement is Element) {
      final Element elem = e.toElement;
      final pair = _getPair(elem);
      if(pair != null) {
        _thePair = new core.Tuple(_candidates[pair.Item1], _candidates[pair.Item2]);
        return;
      }
    }
    _thePair = null;
  }

  void _onMouseOut(args) {
    assert(_candidates != null);
    _thePair = null;
  }

  String _getPairElementName(can1, can2) {
    final cIndex = _candidates.indexOf(can1);
    assert(cIndex >= 0);
    final oIndex = _candidates.indexOf(can2);
    assert(oIndex >= 0);

    return "pair${Math.min(cIndex, oIndex)}_${Math.max(cIndex, oIndex)}";
  }

  static core.Tuple<int, int> _getPair(Element elem) {
    String pairIdStr = elem.dataAttributes[_pairIdsKey];
    if(pairIdStr != null) {
      assert(pairIdStr.startsWith('pair'));
      pairIdStr = pairIdStr.substring(4);

      final idStrs = pairIdStr.split('_');
      assert(idStrs.length == 2);
      final ids = core.$(idStrs).select((s) => Math.parseInt(s)).toList();
      return new core.Tuple<int, int>(ids[0], ids[1]);
    }
    return null;
  }
}
