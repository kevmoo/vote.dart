part of vote_html;

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

  Stream<EventArgs> get hoverChanged => _hoverChangedHandle.stream;

  List<Player> get highlightCandidates {
    if(_highlightRound == null) {
      return null;
    } else {
      final round = _election.rounds[_highlightRound];
      return round.candidates.toList();
    }
  }

  void updateElement() {
    node.children.clear();

    if(election == null) {
      return;
    }

    final candidates = _election.rounds.first.places
        .expand((p) => p)
        .toReadOnlyCollection();

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
        row.insertCell(-1).innerHtml = '&nbsp;';

        for(final place in round.places) {
          cell = new Element.tag('th');
          row.children.add(cell);
          cell.colSpan = place.length;
          cell.innerHtml = place.place.toString();
          cell.classes.add('candidate-cell');
        }

        //
        // 1.2) Candidates
        //
        row = table.insertRow(-1);

        // blank cell on the left
        row.insertCell(-1).innerHtml = '&nbsp;';

        for(final place in round.places) {
          for(final c in place) {
            cell = new Element.tag('th');
            row.children.add(cell);
            cell.innerHtml = c.toString();
            cell.classes.add('candidate-cell');
            cell.style.background = getCandidateHexColor(c);
          }
        }
      }

      //
      // 2) Vote count
      //
      row = table.insertRow(-1);

      // blank cell on the left
      cell = new Element.tag('th');
      cell.innerHtml = 'Round ${i+1}';
      cell.classes.add(_roundCellClass);
      cell.dataset['roundIndex'] = i.toString();
      row.children.add(cell);

      for(final place in round.places) {
        for(final c in place) {
          cell = row.insertCell(-1);
          cell.innerHtml = place.voteCount.toString();
          cell.classes.add('candidate-cell');
          cell.classes.add('vote-count');
          cell.style.background = getCandidateHexColor(c);
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
        cell.innerHtml = elimination.candidate.toString();

        // TODO: use CSS for these
        cell.style.fontStyle = 'italic';
        cell.style.textAlign = 'right';

        bool foundSelf = false;
        for(final c in round.candidates) {
          cell = row.insertCell(-1);
          if(c == elimination.candidate) {
            cell.innerHtml = '&larr;';
            foundSelf = true;
          } else {
            final transferCount = elimination.getTransferCount(c);
            if(transferCount > 0) {
              cell.innerHtml = transferCount.toString();
              cell.classes.add('vote-count');
            }
          }
        }
        assert(foundSelf);
      }
    }

    table.onMouseMove.listen(_onMouseOver);
    table.onMouseOut.listen(_onMouseOut);

    node.children.add(table);
    _updateHighlightedRound(null);
  }

  void _onMouseOver(MouseEvent e) {
    if(e.toElement is Element) {
      final Element elem = e.toElement;
      if(elem.classes.contains(_roundCellClass)) {
        _updateHighlightedRound(int.parse(elem.dataset['roundIndex']));
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
      _hoverChangedHandle.add(EventArgs.empty);
    }
  }
}
