class IrvView extends HtmlView {
  static const _roundCellClass = 'irv_round';

  final EventHandle<EventArgs> _hoverChangedHandle = new EventHandle<EventArgs>();
  int _highlightRound;

  IrvElection _election;

  IrvView(DivElement node) : super(node);

  IrvElection get election => _election;

  void set election(IrvElection value) {
    _election = value;
    markDirty();
  }

  EventRoot<EventArgs> get hoverChanged => _hoverChangedHandle;

  List<Player> get highlightCandidates {
    if(_highlightRound == null) {
      return null;
    } else {
      final round = _election.rounds[_highlightRound];
      return round.candidates.toList();
    }
  }

  void updateElement() {
    node.elements.clear();

    if(election == null) {
      return;
    }

    final candidates = _election.rounds.first().places
        .selectMany((p) => p).toReadOnlyCollection();

    final colors = candidates.toHashMap((c) {
      final hue = LocationData.getHue(c);
      final hsl = new HslColor(hue, 1, 0.75);
      return hsl.toRgb().toHex();
    });

    var table = new TableElement();

    TableRowElement row;
    TableCellElement cell;
    ReadOnlyCollection<PluralityElectionPlace> previousPlaces;

    for(var i = 0; i < election.rounds.length; i++) {
      final round = election.rounds[i];

      // first, see if we need to re-draw places
      // a) if there is no previous place, then yes
      // b) if there is a previous place, but it doesn't match the current round
      bool drawPlaces = false;
      if(previousPlaces == null) {
        drawPlaces = true;
      } else if(previousPlaces.length < round.places.length) {
        drawPlaces = true;
      } else {
        for(var i = 0; i < round.places.length; i++) {
          final currentPlace = round.places[i];
          final previousPlace = previousPlaces[i];
          if(currentPlace.length != previousPlace.length) {
            drawPlaces = true;
          } else {
            for(var j = 0; j < currentPlace.length; j++) {
              if(currentPlace[j] != previousPlace[j]) {
                drawPlaces = true;
                break;
              }
            }
          }
        }
        // uh
      }
      previousPlaces = round.places;

      if(drawPlaces) {
        //
        // 1) Draw headers
        //

        //
        // 1.1) Place numbers
        //
        row = table.insertRow(-1);

        // blank cell on the left
        row.insertCell(-1).innerHTML = '&nbsp;';

        for(final place in round.places) {
          cell = new Element.tag('th');
          row.elements.add(cell);
          cell.colSpan = place.length;
          cell.innerHTML = place.place.toString();
          cell.classes.add('candidate-cell');
        }

        //
        // 1.2) Candidates
        //
        row = table.insertRow(-1);

        // blank cell on the left
        row.insertCell(-1).innerHTML = '&nbsp;';

        for(final place in round.places) {
          for(final c in place) {
            cell = new Element.tag('th');
            row.elements.add(cell);
            cell.innerHTML = c.toString();
            cell.classes.add('candidate-cell');
            cell.style.background = colors[c];
          }
        }
      }

      //
      // 2) Vote count
      //
      row = table.insertRow(-1);

      // blank cell on the left
      cell = new Element.tag('th');
      cell.innerHTML = 'Round ${i+1}';
      cell.classes.add(_roundCellClass);
      cell.dataAttributes['roundIndex'] = i;
      row.elements.add(cell);

      for(final place in round.places) {
        for(final c in place) {
          cell = row.insertCell(-1);
          cell.innerHTML = place.voteCount.toString();
          cell.classes.add('candidate-cell');
          cell.style.background = colors[c];
        }
      }

      //
      // 3) Eliminations
      //
      final el = round.eliminations.length;
      for(var ei = 0; ei < el; ei++) {
        final elimination = round.eliminations[el - ei - 1];
        row = table.insertRow(-1);
        cell = row.insertCell(-1);
        cell.innerHTML = elimination.candidate.toString();

        // TODO: use CSS for these
        cell.style.fontStyle = 'italic';
        cell.style.textAlign = 'right';

        bool foundSelf = false;
        for(final c in round.candidates) {
          cell = row.insertCell(-1);
          if(c == elimination.candidate) {
            cell.innerHTML = '&larr;';
            foundSelf = true;
          } else {
            final transferCount = elimination.getTransferCount(c);
            if(transferCount > 0) {
              cell.innerHTML = transferCount.toString();
            }
          }
        }
        assert(foundSelf);
      }
    }

    table.on.mouseMove.add(_onMouseOver);
    table.on.mouseOut.add(_onMouseOut);

    node.elements.add(table);
    _updateHighlightedRound(null);
  }

  void _onMouseOver(MouseEvent e) {
    if(e.toElement is Element) {
      final Element elem = e.toElement;
      if(elem.classes.contains(_roundCellClass)) {
        _updateHighlightedRound(int.parse(elem.dataAttributes['roundIndex']));
        return;
      }
    }
    _updateHighlightedRound(null);
  }

  void _onMouseOut(args) {
    _updateHighlightedRound(null);
  }

  void _updateHighlightedRound(int roundIndex) {
    if(roundIndex != _highlightRound) {
      _highlightRound = roundIndex;
      _hoverChangedHandle.fireEvent(EventArgs.empty);
    }
  }
}
