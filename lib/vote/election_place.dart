class ElectionPlace<TCandidate extends Player>
  extends ReadOnlyCollection<TCandidate> {
  final int place;

  ElectionPlace._internal(this.place, Iterable<TCandidate> candidates) :
    super(candidates);

  factory ElectionPlace(int place, Iterable<TCandidate> candidates) {
    assert(place > 0);
    assert(candidates != null);
    return new ElectionPlace._internal(place, new List<TCandidate>.from(candidates));
  }
}
