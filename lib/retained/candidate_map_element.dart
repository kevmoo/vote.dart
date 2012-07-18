class CandidateMapElement extends ElementParentImpl {
  final List<MapPlayer> _players;
  final core.AffineTransform _tx;

  num _radius = 0;
  core.Func1<MapPlayer, num> _mapper;
  List<CandidateElement> _elements;

  CandidateMapElement(int w, int h) :
    _tx = new core.AffineTransform(),
    _players = new List<MapPlayer>(),
    super(w, h);

  int get visualChildCount() => _players.length;

  PElement getVisualChild(int index){
    _ensureElements();
    return _elements[index];
  }

  void setTransform(core.AffineTransform value) {
    core.requireArgumentNotNull(value, 'value');
    _tx.setFromTransfrom(value);
    invalidateDraw();
  }

  Iterable<MapPlayer> get players() => _players;

  void set players(Collection<MapPlayer> value) {
    core.requireArgumentNotNull(value, "value");
    _players.clear();
    _players.addAll(value);
    _elements = null;
    invalidateDraw();
  }

  void _ensureElements() {
    if(_elements == null) {
      _elements = new List<CandidateElement>();
      for(final p in _players) {
        final hue = _mapper(p);
        final rgb = (new core.HslColor(hue, 0.5, 0.6)).toRgb();
        final ce = new CandidateElement(_radius * 4, _radius * 4,
          rgb.toHex(), p);
        ce.registerParent(this);
        final tempTx = ce.addTransform();
        tempTx.concatenate(_tx);
        tempTx.translate(p.location.x - 2 * _radius, p.location.y - 2 * _radius);

        _elements.add(ce);
      }
    }
  }
}
