import 'dart:collection';
import 'dart:math' as math;

void require(bool truth, [String message]) {
  if (!truth) {
    throw new Exception(message);
  }
}

void requireArgument(bool truth, String argName, [String message]) {
  if (!truth) {
    if (message == null || message.isEmpty) {
      message = 'value was invalid';
    }
    throw new ArgumentError([argName, message]);
  }
}

void requireArgumentNotNull(argument, String argName) {
  if (argument == null) {
    throw new ArgumentError.notNull(argName);
  }
}

bool allUnique(Iterable items) {
  requireArgumentNotNull(items, 'items');

  for (int i = 0; i < items.length; i++) {
    for (int j = i + 1; j < items.length; j++) {
      if (items.elementAt(i) == items.elementAt(j)) {
        return false;
      }
    }
  }
  return true;
}

int _combine(int hash, Object o) {
  assert(o is! Iterable);
  hash = 0x1fffffff & (hash + o.hashCode);
  hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
  return hash ^ (hash >> 6);
}

int _finish(int hash) {
  hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
  hash = hash ^ (hash >> 11);
  return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
}

int hashValues(Object arg01, Object arg02) {
  int result = 0;
  result = _combine(result, arg01);
  result = _combine(result, arg02);

  return _finish(result);
}

/// [Tarjan's strongly connected components algorithm](http://en.wikipedia.org/wiki/Tarjan's_strongly_connected_components_algorithm)
List<List<T>> stronglyConnectedComponents<T>(Map<dynamic, Iterable<T>> graph) {
  requireArgumentNotNull(graph, 'graph');

  var nodes = new _Graph<T>(graph);
  var tarjan = new _TarjanCycleDetect<T>(nodes);
  return tarjan.calculate();
}

class _TarjanCycleDetect<T> {
  final _indexExpando = new Expando<int>('index');
  final _linkExpando = new Expando<int>('link');

  final Queue<_GraphNode<T>> _stack = new Queue<_GraphNode<T>>();
  final List<List<T>> _scc = new List<List<T>>();
  final _Graph<T> _list;

  int _index = 0;

  _TarjanCycleDetect(this._list);

  List<List<T>> calculate() {
    for (var node in _list.nodes) {
      if (_getIndex(node) == -1) {
        _tarjan(node);
      }
    }
    return _scc;
  }

  void _tarjan(_GraphNode<T> v) {
    _setIndex(v, _index);
    _setLowLink(v, _index);
    _index++;
    _stack.addFirst(v);
    for (final n in v.outNodes) {
      if (_getIndex(n) == -1) {
        _tarjan(n);
        _setLowLink(v, math.min(_getLowLink(v), _getLowLink(n)));
      } else if (_stack.contains(n)) {
        _setLowLink(v, math.min(_getLowLink(v), _getIndex(n)));
      }
    }
    if (_getLowLink(v) == _getIndex(v)) {
      _GraphNode n;
      var component = new List<T>();
      do {
        n = _stack.removeFirst();
        component.add(n.value);
      } while (n != v);
      _scc.add(component);
    }
  }

  int _getIndex(_GraphNode<T> node) {
    var value = _indexExpando[node];
    return (value == null) ? -1 : value;
  }

  int _setIndex(_GraphNode<T> node, int value) => _indexExpando[node] = value;

  int _getLowLink(_GraphNode<T> node) => _linkExpando[node];

  int _setLowLink(_GraphNode<T> node, int value) => _linkExpando[node] = value;
}

class _Graph<T> {
  final LinkedHashMap<T, _GraphNode<T>> _map;

  factory _Graph(Map<T, Iterable<T>> items) {
    var map = new LinkedHashMap<T, _GraphNode<T>>();

    _GraphNode<T> getNode(T value) =>
        map.putIfAbsent(value, () => new _GraphNode<T>(value));

    items.forEach((T item, Iterable<T> outLinks) {
      if (outLinks == null) outLinks = <T>[];

      var node = getNode(item);
      for (T outLink in outLinks) {
        var newItem = node.outNodes.add(getNode(outLink));
        requireArgument(newItem, 'items', 'Outlinks must not contain dupes');
      }
    });

    return new _Graph.core(map);
  }

  _Graph.core(this._map);

  Iterable<_GraphNode<T>> get nodes => _map.values;

  @override
  String toString() {
    var sb = new StringBuffer();
    sb.writeln('{');
    _map.values.forEach((_GraphNode<T> value) {
      var outNodeStr = value.outNodes.map((gn) => gn.value).join(', ');

      sb.writeln('  ${value.value} => {$outNodeStr}');
    });

    sb.writeln('}');
    return sb.toString();
  }
}

class _GraphNode<T> {
  final T value;
  final LinkedHashSet<_GraphNode<T>> outNodes =
      new LinkedHashSet<_GraphNode<T>>();

  _GraphNode(this.value);

  @override
  bool operator ==(other) => other is _GraphNode && other.value == value;

  @override
  int get hashCode => value.hashCode;
}
