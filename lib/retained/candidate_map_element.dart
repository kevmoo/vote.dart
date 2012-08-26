class CandidateMapElement extends ElementParentImpl implements MapElementBase {
  final List<MapPlayer> _players;
  final core.AffineTransform _tx;

  num _radius = 0;
  List<CandidateElement> _elements;
  core.ReadOnlyCollection<MapPlayer> _showOnlyPlayers;

  CandidateMapElement(int w, int h) :
    _tx = new core.AffineTransform(),
    _players = new List<MapPlayer>(),
    super(w, h) {
    showOnlyPlayers = null;
  }

  int get visualChildCount {
    _ensureElements();
    return _elements.length;
  }

  PElement getVisualChild(int index){
    _ensureElements();
    return _elements[index];
  }

  void setTransform(core.AffineTransform value) {
    core.requireArgumentNotNull(value, 'value');
    _tx.setFromTransfrom(value);
    invalidateDraw();
  }

  Iterable<MapPlayer> get players => _players;

  void set players(Collection<MapPlayer> value) {
    core.requireArgumentNotNull(value, "value");
    _players.clear();
    _players.addAll(value);
    _elements = null;
    invalidateDraw();
  }

  Collection<MapPlayer> get showOnlyPlayers => _showOnlyPlayers;

  void set showOnlyPlayers(Iterable<MapPlayer> value) {
    if(value == null) {
      _showOnlyPlayers = null;
    } else {
      var newVal = core.$(value).toReadOnlyCollection();
      assert(newVal.distinct().count() == newVal.length);
      assert(newVal.every((e) => _players.indexOf(e) >= 0));
      _showOnlyPlayers = newVal;
    }

    if(_elements == null) {
      invalidateDraw();
    } else {
      _updateCandidateElements();
    }
  }

  void _ensureElements() {
    if(_elements == null) {
      _elements = new List<CandidateElement>();
      for(final p in _players) {
        final hue = LocationData.getHue(p);
        final rgb = (new core.HslColor(hue, 0.5, 0.6)).toRgb();
        final ce = new CandidateElement(_radius * 4, _radius * 4,
          rgb.toHex(), p);
        ce.registerParent(this);
        final tempTx = ce.addTransform();
        tempTx.concatenate(_tx);
        tempTx.translate(p.location.x - 2 * _radius, p.location.y - 2 * _radius);

        _elements.add(ce);
      }
      _updateCandidateElements();
    }
  }

  void _updateCandidateElements() {
    assert(_elements != null);
    for(final e in _elements) {
      e.hidden = _showOnlyPlayers != null && _showOnlyPlayers.indexOf(e.player) < 0;
    }
  }
}
