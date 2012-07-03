class MapPlayer implements Player {
  final GlobalId _id;
  Coordinate _location;

  MapPlayer(Coordinate value) :
    _id = new GlobalId() {
    location = value;
  }

  Coordinate get location() => _location;

  void set location(Coordinate value) {
    requireArgumentNotNull(value, 'value');
    _location = value;
  }

  int compareTo(MapPlayer other) => _id.compareTo(other._id);

  int hashCode() => _id.hashCode();

  String toString() => "MapPlayer at $_location";
}
