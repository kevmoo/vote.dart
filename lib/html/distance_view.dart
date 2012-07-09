class DistanceView {
  final DivElement _node;
  core.Func1<MapPlayer, num> _mapper;
  Iterable<MapPlayer> _voters;
  Iterable<MapPlayer> _candidates;
  List<core.Tuple<MapPlayer, num>> _distances;

  DistanceView(this._node,
    [core.Func1<MapPlayer, num> mapper, Iterable<MapPlayer> voters = null, Iterable<MapPlayer> candidates= null]) {
    _mapper = mapper;
    _voters = voters;
    _candidates = candidates;
    _updateElement();
  }

  void setCandidateColorMap(core.Func1<MapPlayer, num> value) {
    _mapper = value;
    _updateElement();
  }

  void setVoters(Iterable<MapPlayer> value) {
    _voters = value;
    _distances = null;
    _updateElement;
  }

  void setCandidates(Iterable<MapPlayer> value) {
    _candidates = value;
    _distances = null;
    _updateElement();
  }

  void _updateElement() {
    _node.elements.clear();

    var table = new TableElement();
    TableRowElement row = table.insertRow(-1);
    TableCellElement cell = new Element.tag('th');
    row.elements.add(cell);
    cell.colSpan = 2;
    cell.innerHTML = "Distance";

    row = table.insertRow(-1);
    cell = new Element.tag('th');
    row.elements.add(cell);
    cell.innerHTML = "Place";

    cell = new Element.tag('th');
    row.elements.add(cell);
    cell.innerHTML = "Candidate";

    cell = new Element.tag('th');
    row.elements.add(cell);
    row.classes.add('distance-row-odd');
    cell.innerHTML = "Distance";

    var evenCandidateRow = true;

    _updateDistances();
    if(_distances != null) {
      for(var i = 0; i < _distances.length; i++) {
        final pair = _distances[i];

        row = table.insertRow(-1);
        row.classes.add(evenCandidateRow ? 'row-even' : 'row-odd');

        cell = new Element.tag('th');
        row.elements.add(cell);
        cell.classes.add('place-number');
        cell.innerHTML = (i+1).toString();

        cell = row.insertCell(-1);
        cell.classes.add('candidate-cell');
        if(_mapper != null) {
          final hue = _mapper(pair.Item1);
          if(hue != null) {
            final hsl = new core.HslColor(hue, 1, 0.75);
            final rgb = hsl.toRgb();
            cell.style.background = rgb.toHex();
          }
        }
        cell.innerHTML = pair.Item1.toString();

        cell = row.insertCell(-1);
        cell.classes.add('average-distance');
        cell.innerHTML = pair.Item2.toStringAsFixed(1);


        evenCandidateRow = !evenCandidateRow;
      }
    }

    _node.elements.add(table);
  }

  void _updateDistances() {
    if(_voters != null && _candidates != null) {
      if(_distances == null) {
        _distances = new List<core.Tuple<MapPlayer, num>>();
        for(final candidate in _candidates) {
          num totalDistance = 0;
          int count = 0;
          for(final v in _voters) {
            totalDistance += candidate.location.getDistance(v.location);
            count++;
          }
          _distances.add(new core.Tuple<MapPlayer, num>(candidate, totalDistance / count));
        }

        // sort!
        _distances.sort((p1, p2) => p1.Item2.compareTo(p2.Item2));
      }
    } else {
      _distances = null;
    }
  }
}
