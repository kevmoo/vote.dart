class MapPlayer implements Player {
  final GlobalId _id;
  Coordinate _location;
  String name;

  MapPlayer(Coordinate value) :
    _id = new GlobalId() {
    location = value;
  }

  Coordinate get location() => _location;

  void set location(Coordinate value) {
    requireArgumentNotNull(value, 'value');
    _location = value;
  }

  int get id() => _id.id;

  int compareTo(MapPlayer other) => _id.compareTo(other._id);

  int hashCode() => _id.hashCode();

  bool operator ==(MapPlayer other) => other !== null && other._id == _id;

  String toString() {
    if(name == null) {
      return "MapPlayer at [${_location.x.toStringAsFixed(1)}, ${_location.y.toStringAsFixed(1)}]";
    } else {
      return name;
    }
  }
}
