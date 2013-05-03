part of vote_map;

class LocationData {
  static const int maxCandidateCount = 26;
  static const Box bounds = const Box(0,0, span, span);
  static const int _ACharCode = 65;
  static const num span = 10;
  final ReadOnlyCollection<MapPlayer> candidates;
  final ReadOnlyCollection<MapPlayer> voters;

  static List<num> _candidateHues;

  LocationData(this.voters, this.candidates) {
    assert(this.candidates.length > 0);
  }

  factory LocationData.random() {
    final spanTweak = span / (span - 1);

    // 100 voters from 1,1 to 10,10
    final voters = new List<MapPlayer>();
    for(var i = 0; i < span; i++) {
      for(var j = 0; j < span; j++) {
        voters.add(new MapPlayer(new Coordinate(i * spanTweak, j * spanTweak)));
      }
    }

    final coords = new List<Vector>();
    final middle = new Vector(0.5, 0.5);
    coords.add(middle);

    final bool mirror = false;

    for(var i = 0; i < 4; i++) {
      var coord = new Vector(rnd.nextDouble(), rnd.nextDouble());
      coords.add(coord);
      if(mirror) {
        final delta = middle - coord;
        coords.add(middle + delta);
        i++;
      }
    }

    final candidates = new List<MapPlayer>();
    $(coords)
      .map((c) => c.scale(span))
      .forEachWithIndex((c,i) {
        final candidate = new MapPlayer(c, getCandidateName(i));
        candidates.add(candidate);
      });

    return new LocationData(
      new ReadOnlyCollection<MapPlayer>.wrap(voters),
      new ReadOnlyCollection<MapPlayer>.wrap(candidates));

  }

  LocationData cloneAndRemove(MapPlayer mp) {
    requireArgumentNotNull(mp, 'mp');

    var newCans = new ReadOnlyCollection(candidates.where((e) => e != mp));

    return new LocationData(voters, newCans);
  }

  LocationData cloneAndAddCandidate() {
    assert(candidates.length < 26);
    var newCans = candidates.toList();

    int i;
    for(i = 0; i < newCans.length; i++) {
      final mp = newCans[i];
      assert(mp.name.length == 1);
      final mpCC = mp.name.codeUnitAt(0);
      final letterIndex = mpCC - _ACharCode;
      assert(letterIndex >= i);

      if(letterIndex > i) {
        break;
      }
    }

    final newName = getCandidateName(i);

    var coord = new Vector(rnd.nextDouble(), rnd.nextDouble());
    final loc = coord.scale(span);
    final mp = new MapPlayer(loc, newName);

    newCans.insert(i, mp);

    return new LocationData(voters, new ReadOnlyCollection(newCans));
  }

  static num getHue(MapPlayer candidate) {
    if(_candidateHues == null) {
      _candidateHues = _slice(maxCandidateCount, 360, 3);
    }
    final letter = candidate.name;
    assert(letter != null && letter.length == 1);
    final letterCode = (letter.codeUnitAt(0) - _ACharCode);
    assert(letterCode >= 0 && letterCode < maxCandidateCount);

    return _candidateHues[letterCode];
  }

  static List<num> _slice(int itemCount, num maxValue, int sliceCount) {
    assert(itemCount > 0);
    assert(isValidNumber(maxValue));
    assert(maxValue > 0);
    assert(sliceCount > 1);

    final values = new List<num>(itemCount);
    int index = 0;

    num sliceSize = maxValue / sliceCount;

    for(int i = 0; i < sliceCount; i++) {
      if(index == itemCount) {
        return values;
      } else {
        values[index++] = i * sliceSize;
      }
    }

    while(true) {
      final startCount = index;
      sliceSize = maxValue / (startCount * 2);

      for(int i = 0; i < startCount; i++) {
        if(index == itemCount) {
          return values;
        } else {
          values[index++] = values[i] + sliceSize;
        }
      }
    }
  }

  static String getCandidateName(int i) {
    requireArgument(i >= 0, 'i');
    requireArgument(i < maxCandidateCount, 'i');
    return new String.fromCharCodes([i + _ACharCode]);
  }
}
