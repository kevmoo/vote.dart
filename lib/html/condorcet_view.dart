part of vote.html;

class CondorcetView extends HtmlView {
  static const String _PAIS_IDS_KEY = 'pair-ids';

  final StreamController _hoverChangedHandle = new StreamController();
  CondorcetElection _election;
  ReadOnlyCollection<Player> _candidates;
  List<Player> _highlightCandidates;

  CondorcetView(DivElement node) : super(node);

  CondorcetElection get election => _election;

  void set election(CondorcetElection election) {
    _election = election;
    _candidates = null;
    markDirty();
  }

  Stream get hoverChanged => _hoverChangedHandle.stream;

  List<Player> get highlightCandidates => _highlightCandidates;

  void updateElement() {
    node.children.clear();

    var table = new TableElement();

    TableRowElement row = table.insertRow(-1);
    TableCellElement cell = new Element.tag('th');
    row.children.add(cell);
    row.classes.add('row-odd');
    cell.innerHtml = "Place";

    cell = new Element.tag('th');
    row.children.add(cell);
    cell.innerHtml = "Candidate";

    if(_election != null) {
      var evenPlaceRow = true;
      var evenCandidateRow = true;

      // add columns for opponents
      _candidates = _election.places.expand((p) => p).toReadOnlyCollection();

      for(final opp in _candidates) {
        cell = new Element.tag('th');
        row.children.add(cell);
        cell.innerHtml = opp.toString();

        cell.style.background = getCandidateHexColor(opp);
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
            row.children.add(cell);
            cell.classes.add('place-number');
            cell.rowSpan = place.length;
            cell.innerHtml = place.place.toString();
          }

          cell = row.insertCell(-1);
          cell.classes.add('candidate-cell');

          cell.style.background = getCandidateHexColor(candidate);
          cell.innerHtml = candidate.toString();

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
                leftColor = getCandidateHexColor(candidate, true);
                rightColor = getCandidateHexColor(opp, true);
                middleText = '&gt;';
              } else if(opp == pair.winner) {
                cellClass = 'loser';
                leftColor = getCandidateHexColor(candidate);
                rightColor = getCandidateHexColor(opp);
                middleText = '&lt;';
              } else {
                assert(pair.isTie);
                cellClass = 'tie';
                leftColor = getCandidateHexColor(candidate, true);
                rightColor = getCandidateHexColor(opp, true);
                middleText = '=';
              }

              final cellData = _getPairElementName(candidate, opp);

              cell = row.insertCell(-1);
              cell.innerHtml = pair.firstOverSecond.toString();
              cell.style.color = leftColor;
              cell.classes.add('vote-count');
              cell.classes.add('pair-cell');
              cell.classes.add(cellData);
              cell.classes.add(cellClass);
              cell.classes.add('left_value');
              cell.dataset[_PAIS_IDS_KEY] = cellData;

              cell = row.insertCell(-1);
              cell.innerHtml = middleText;
              cell.classes.add('pair-cell');
              cell.classes.add(cellClass);
              cell.classes.add(cellData);
              cell.dataset[_PAIS_IDS_KEY] = cellData;

              cell = row.insertCell(-1);
              cell.innerHtml = pair.secondOverFirst.toString();
              cell.style.color = rightColor;
              cell.classes.add('vote-count');
              cell.classes.add('right_value');
              cell.classes.add(cellClass);
              cell.classes.add('pair-cell');
              cell.classes.add(cellData);
              cell.dataset[_PAIS_IDS_KEY] = cellData;
            }
          }

          evenCandidateRow = !evenCandidateRow;
        }
        evenPlaceRow = !evenPlaceRow;
      }

    }

    table.onMouseMove.listen(_onMouseOver);
    table.onMouseOut.listen(_onMouseOut);

    node.children.add(table);
  }

  void set _thePair(List<Player> pair) {
    assert(_candidates != null);
    if(pair != _highlightCandidates) {
      _highlightCandidates = pair;
      _updateCellHoverStyle();
      _hoverChangedHandle.add(null);
    }
  }

  void _updateCellHoverStyle() {
    final String hoverPairClass = 'hover-pair';

    final List<Element> cells = node.querySelectorAll('td.pair-cell.$hoverPairClass');
    cells.forEach((e){
      e.classes.remove(hoverPairClass);
    });

    if(_highlightCandidates != null) {
      final matchClass =
          _getPairElementName(_highlightCandidates[0], _highlightCandidates[1]);
      final List<Element> thePairs = node.querySelectorAll('td.pair-cell.$matchClass');
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
        _thePair = [_candidates[pair.item1], _candidates[pair.item2]];
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

    return "pair${math.min(cIndex, oIndex)}_${math.max(cIndex, oIndex)}";
  }

  static Tuple<int, int> _getPair(Element elem) {
    String pairIdStr = elem.dataset[_PAIS_IDS_KEY];
    if(pairIdStr != null) {
      assert(pairIdStr.startsWith('pair'));
      pairIdStr = pairIdStr.substring(4);

      final idStrs = pairIdStr.split('_');
      assert(idStrs.length == 2);
      final ids = idStrs.map((s) => int.parse(s)).toList();
      return new Tuple<int, int>(ids[0], ids[1]);
    }
    return null;
  }
}
