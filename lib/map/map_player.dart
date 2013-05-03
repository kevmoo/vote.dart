part of vote_map;

class MapPlayer extends Player {
  static int _counter = 0;

  final int _id;
  final String name;
  Coordinate _location;

  MapPlayer(this._location, [this.name = null]) :
    _id = _counter++;

  Coordinate get location => _location;

  void set location(Coordinate value) {
    requireArgumentNotNull(value, 'value');
    _location = value;
  }

  int get id => _id;

  int compareTo(MapPlayer other) => _id.compareTo(other._id);

  int get hashCode => _id.hashCode;

  bool operator ==(MapPlayer other) => other != null && other._id == _id;

  String toString() {
    if(name == null) {
      return "MapPlayer at [${_location.x.toStringAsFixed(1)}, ${_location.y.toStringAsFixed(1)}]";
    } else {
      return name;
    }
  }
}
