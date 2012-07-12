class MapElectionPlace<TCandidate extends MapPlayer>
  extends ElectionPlace<TCandidate> {
  final num avgDistance;
  final num avgDistanceSquared;

  MapElectionPlace(int place, Iterable<TCandidate> candidates,
    this.avgDistance, this.avgDistanceSquared) :
    super(place, candidates);
}
