class ElectionView {
  final DivElement _node;
  bool _dirty;

  ElectionView(this._node) {
    _dirty = true;
  }

  DivElement get node() => _node;

  void markDirty() {
    _dirty = true;
  }

  void draw() {
    if(_dirty) {
      _updateElement();
      _dirty = false;
    }
  }

  abstract void _updateElement();
}
