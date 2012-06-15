class ElectionPlace<TCandidate extends Player>
  extends ListBase<TCandidate> {
  final List<TCandidate> _candidates;
  final int place;

  ElectionPlace._internal(this.place, this._candidates);

  factory ElectionPlace(int place, Iterable<TCandidate> candidates) {
    assert(place > 0);
    assert(candidates != null);
    return new ElectionPlace._internal(place, new List<TCandidate>.from(candidates));
  }

  int get length() => _candidates.length;

  TCandidate operator [](int index) {
    return _candidates[index];
  }
}
