class CandidateMap extends PlayerMap implements IElementParent {
  List<CandidateElement> _elements;

  CandidateMap(int w, int h) :
    super(w, h);

  void childInvalidated(PElement child){
    assert(hasVisualChild(child));
    invalidateDraw();
  }

  int get visualChildCount() => _players.length;

  PElement getVisualChild(int index){
    _ensureElements();
    return _elements[index];
  }

  void update(){
    var length = visualChildCount;
    for(var i=0;i<length;i++){
      final element = getVisualChild(i);
      element.update();
    }
    super.update();
  }

  void drawOverride(CanvasRenderingContext2D ctx){
    var length = visualChildCount;
    for(var i=0;i<length;i++){
      var element = getVisualChild(i);
      element.drawInternal(ctx);
    }
  }

  void _ensureElements() {
    if(_elements == null) {
      _elements = new List<CandidateElement>();
      for(final p in _players) {
        final hue = _mapper(p);
        final rgb = (new core.HslColor(hue, 0.5, 0.6)).toRgb();
        final ce = new CandidateElement(_radius * 4, _radius * 4,
          rgb.toHex(), p.name);
        ce.claim(this);
        final tempTx = ce.addTransform();
        tempTx.concatenate(_tx);
        tempTx.translate(p.location.x - 2 * _radius, p.location.y - 2 * _radius);

        _elements.add(ce);
      }
    }
  }
}
