class Candidate(final String id, final double hue)
    implements Comparable<Candidate> {
  @override
  int compareTo(Candidate other) => id.compareTo(other.id);

  @override
  bool operator ==(Object other) => other is Candidate && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => id;
}

const colorSaturation = 0.3;

const int maxCandidateCount = 26;

final List<double> candidateHues = _slice(maxCandidateCount, 360, 3);

List<double> _slice(int itemCount, num maxValue, int sliceCount) {
  assert(itemCount > 0);
  assert(maxValue > 0);
  assert(sliceCount > 1);

  final values = List<double>.filled(itemCount, 0);
  var index = 0;

  var sliceSize = maxValue / sliceCount;

  for (var i = 0; i < sliceCount; i++) {
    if (index == itemCount) {
      return values;
    } else {
      values[index++] = i * sliceSize;
    }
  }

  for (;;) {
    final startCount = index;
    sliceSize = maxValue / (startCount * 2);

    for (var i = 0; i < startCount; i++) {
      if (index == itemCount) {
        return values;
      } else {
        values[index++] = values[i] + sliceSize;
      }
    }
  }
}
