part of vote_html;

class CandidateManagerView extends HtmlView {
  static final String _candidateIdAttribute = 'candidate-id';
  final EventHandle<MapPlayer> _requestRemoveCandidateHandle;
  final EventHandle<EventArgs> _requestNewCandidateHandle;
  ReadOnlyCollection<MapPlayer> _candidates;

  CandidateManagerView(DivElement node) :
    _requestRemoveCandidateHandle = new EventHandle<MapPlayer>(),
    _requestNewCandidateHandle = new EventHandle<EventArgs>(),
    _candidates = new ReadOnlyCollection<MapPlayer>.empty(),
    super(node);

  void set candidates(ReadOnlyCollection<MapPlayer> value) {
    assert(value != null);
    _candidates = value;
    markDirty();
  }

  EventRoot<MapPlayer> get candidateRemoveRequest =>
      _requestRemoveCandidateHandle;

  EventRoot<EventArgs> get newCandidateRequest =>
      _requestNewCandidateHandle;

  void updateElement() {
    node.elements.clear();

    var table = new TableElement();

    TableRowElement row = table.insertRow(-1);
    TableCellElement cell = row.insertCell(-1);
    cell.colSpan = 2;

    final addButton = new ButtonElement();
    addButton.text = "Add Candidate";
    if(_candidates.length < LocationData.maxCandidateCount) {
      addButton.on.click.add(_requestNewCandidate);
    } else {
      addButton.disabled = true;
    }

    cell.elements.add(addButton);

    if(_candidates != null) {
      for(final candidate in _candidates) {
        row = table.insertRow(-1);

        final hue = LocationData.getHue(candidate);
        if(hue != null) {
          final hsl = new HslColor(hue, 1, 0.75);
          final rgb = hsl.toRgb();
          row.style.background = rgb.toHex();
        }

        cell = row.insertCell(-1);
        cell.classes.add('candidate-cell');
        cell.innerHTML = candidate.toString();

        cell = row.insertCell(-1);
        final deleteButton = new ButtonElement();
        deleteButton.text = 'Delete';
        deleteButton.dataAttributes[_candidateIdAttribute] = candidate.id.toString();
        if(_candidates.length > 1) {
          deleteButton.on.click.add(_deleteClick);
        } else {
          deleteButton.disabled = true;
        }
        cell.elements.add(deleteButton);
      }
    }
    node.elements.add(table);
  }

  void _requestNewCandidate(MouseEvent args) {
    final ButtonElement source = args.toElement;
    _requestNewCandidateHandle.fireEvent(EventArgs.empty);
    source.disabled = true;
  }

  void _deleteClick(MouseEvent args) {
    final ButtonElement source = args.toElement;
    final candidateId = int.parse(source.dataAttributes[_candidateIdAttribute]);
    _removeCandidateWithId(candidateId);
    source.disabled = true;
  }

  void _removeCandidateWithId(int id) {
    final candidate = _candidates.single((mp) => mp.id == id);

    _requestRemoveCandidateHandle.fireEvent(candidate);
  }
}
