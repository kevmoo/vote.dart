part of vote.map;

class LocationData {
  static const int MAX_CANDIDATE_COUNT = 26;
  static const Rectangle BOUNDS = const Rectangle(0, 0, SPAN, SPAN);
  static const int _A_CHAR_CODE = 65;
  static const num SPAN = 10;

  static List<num> _candidateHues;

  final List<MapPlayer> candidates;
  final List<MapPlayer> voters;

  LocationData(this.voters, this.candidates) {
    assert(this.candidates.length > 0);
  }

  factory LocationData.random() {
    final spanTweak = SPAN / (SPAN - 1);

    // 100 voters from 1,1 to 10,10
    final voters = new List<MapPlayer>();
    for (var i = 0; i < SPAN; i++) {
      for (var j = 0; j < SPAN; j++) {
        voters.add(new MapPlayer(new Coordinate(i * spanTweak, j * spanTweak)));
      }
    }

    final coords = new List<Vector>();
    final middle = new Vector(0.5, 0.5);
    coords.add(middle);

    final bool mirror = false;

    for (var i = 0; i < 4; i++) {
      var coord = new Vector(rnd.nextDouble(), rnd.nextDouble());
      coords.add(coord);
      if (mirror) {
        final delta = middle - coord;
        coords.add(middle + delta);
        i++;
      }
    }

    final candidates = new List<MapPlayer>();
    $(coords).map((c) => c.scale(SPAN)).forEachWithIndex((c, i) {
      final candidate = new MapPlayer(c, getCandidateName(i));
      candidates.add(candidate);
    });

    return new LocationData(new List<MapPlayer>.unmodifiable(voters),
        new List<MapPlayer>.unmodifiable(candidates));
  }

  LocationData cloneAndRemove(MapPlayer mp) {
    requireArgumentNotNull(mp, 'mp');

    var newCans = new List.unmodifiable(candidates.where((e) => e != mp));

    return new LocationData(voters, newCans);
  }

  LocationData cloneAndAddCandidate() {
    assert(candidates.length < 26);
    var newCans = candidates.toList();

    int i;
    for (i = 0; i < newCans.length; i++) {
      final mp = newCans[i];
      assert(mp.name.length == 1);
      final mpCC = mp.name.codeUnitAt(0);
      final letterIndex = mpCC - _A_CHAR_CODE;
      assert(letterIndex >= i);

      if (letterIndex > i) {
        break;
      }
    }

    final newName = getCandidateName(i);

    var coord = new Vector(rnd.nextDouble(), rnd.nextDouble());
    final loc = coord.scale(SPAN);
    final mp = new MapPlayer(loc, newName);

    newCans.insert(i, mp);

    return new LocationData(voters, new List.unmodifiable(newCans));
  }

  static num getHue(MapPlayer candidate) {
    if (_candidateHues == null) {
      _candidateHues = _slice(MAX_CANDIDATE_COUNT, 360, 3);
    }
    final letter = candidate.name;
    assert(letter != null && letter.length == 1);
    final letterCode = (letter.codeUnitAt(0) - _A_CHAR_CODE);
    assert(letterCode >= 0 && letterCode < MAX_CANDIDATE_COUNT);

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

    for (int i = 0; i < sliceCount; i++) {
      if (index == itemCount) {
        return values;
      } else {
        values[index++] = i * sliceSize;
      }
    }

    while (true) {
      final startCount = index;
      sliceSize = maxValue / (startCount * 2);

      for (int i = 0; i < startCount; i++) {
        if (index == itemCount) {
          return values;
        } else {
          values[index++] = values[i] + sliceSize;
        }
      }
    }
  }

  static String getCandidateName(int i) {
    requireArgument(i >= 0, 'i');
    requireArgument(i < MAX_CANDIDATE_COUNT, 'i');
    return new String.fromCharCodes([i + _A_CHAR_CODE]);
  }
}
