part of vote.html;

class CandidateManagerView extends HtmlView {
  static const String _CANDIDATE_ID_ATTRIBUTE = 'candidate-id';
  final StreamController<MapPlayer> _requestRemoveCandidateHandle;
  final StreamController _requestNewCandidateHandle;
  ReadOnlyCollection<MapPlayer> _candidates;

  CandidateManagerView(DivElement node) :
    _requestRemoveCandidateHandle = new StreamController<MapPlayer>(),
    _requestNewCandidateHandle = new StreamController(),
    _candidates = new ReadOnlyCollection<MapPlayer>.empty(),
    super(node);

  void set candidates(ReadOnlyCollection<MapPlayer> value) {
    assert(value != null);
    _candidates = value;
    markDirty();
  }

  Stream<MapPlayer> get candidateRemoveRequest =>
      _requestRemoveCandidateHandle.stream;

  Stream get newCandidateRequest =>
      _requestNewCandidateHandle.stream;

  void updateElement() {
    node.children.clear();

    var table = new TableElement();

    TableRowElement row = table.insertRow(-1);
    TableCellElement cell = row.insertCell(-1);
    cell.colSpan = 2;

    final addButton = new ButtonElement();
    addButton.text = "Add Candidate";
    if(_candidates.length < LocationData.MAX_CANDIDATE_COUNT) {
      addButton.onClick.listen(_requestNewCandidate);
    } else {
      addButton.disabled = true;
    }

    cell.children.add(addButton);

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
        cell.innerHtml = candidate.toString();

        cell = row.insertCell(-1);
        final deleteButton = new ButtonElement();
        deleteButton.text = 'Delete';
        deleteButton.dataset[_CANDIDATE_ID_ATTRIBUTE] = candidate.id.toString();
        if(_candidates.length > 1) {
          deleteButton.onClick.listen(_deleteClick);
        } else {
          deleteButton.disabled = true;
        }
        cell.children.add(deleteButton);
      }
    }
    node.children.add(table);
  }

  void _requestNewCandidate(MouseEvent args) {
    final ButtonElement source = args.toElement;
    _requestNewCandidateHandle.add(null);
    source.disabled = true;
  }

  void _deleteClick(MouseEvent args) {
    final ButtonElement source = args.toElement;
    final candidateId = int.parse(source.dataset[_CANDIDATE_ID_ATTRIBUTE]);
    _removeCandidateWithId(candidateId);
    source.disabled = true;
  }

  void _removeCandidateWithId(int id) {
    final candidate = _candidates.singleWhere((mp) => mp.id == id);

    _requestRemoveCandidateHandle.add(candidate);
  }
}
