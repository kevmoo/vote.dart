class CandidateManagerView extends HtmlView {
  static final String _candidateIdAttribute = 'candidate-id';
  final core.EventHandle<Iterable<MapPlayer>> _requestCandidateUpdateHandle;
  core.ReadOnlyCollection<MapPlayer> _candidates;
  core.Func1<MapPlayer, num> _mapper;

  CandidateManagerView(DivElement node) :
    _requestCandidateUpdateHandle = new core.EventHandle<Iterable<MapPlayer>>(),
    _candidates = new core.ReadOnlyCollection<MapPlayer>.empty(),
    _mapper = ((c) => null),
    super(node);

  void set candidates(core.ReadOnlyCollection<MapPlayer> value) {
    assert(value != null);
    _candidates = value;
    markDirty();
  }

  void set candidateColorMap(core.Func1<MapPlayer, num> value) {
    assert(value != null);
    _mapper = value;
    markDirty();
  }

  core.EventRoot<Iterable<MapPlayer>> get candidateUpdateRequest() =>
      _requestCandidateUpdateHandle;

  void updateElement() {
    _node.elements.clear();

    var table = new TableElement();

    if(_candidates != null) {
      for(final candidate in _candidates) {
        TableRowElement row = table.insertRow(-1);

        final hue = _mapper(candidate);
        if(hue != null) {
          final hsl = new core.HslColor(hue, 1, 0.75);
          final rgb = hsl.toRgb();
          row.style.background = rgb.toHex();
        }

        TableCellElement cell = row.insertCell(-1);
        cell.classes.add('candidate-cell');
        cell.innerHTML = candidate.toString();

        cell = row.insertCell(-1);
        final deleteButton = new ButtonElement();
        deleteButton.text = 'Delete';
        deleteButton.dataAttributes[_candidateIdAttribute] = candidate.id.toString();
        deleteButton.on.click.add(_deleteClick);
        cell.elements.add(deleteButton);
      }
    }
    _node.elements.add(table);
  }

  void _deleteClick(MouseEvent args) {
    final ButtonElement source = args.toElement;
    final candidateId = Math.parseInt(source.dataAttributes[_candidateIdAttribute]);
    _removeCandidateWithId(candidateId);
  }

  void _removeCandidateWithId(int id) {
    final newCandidates = core.$(_candidates)
        .where((mp) => mp.id != id)
        .toReadOnlyCollection();

    _requestCandidateUpdateHandle.fireEvent(newCandidates);
  }
}
