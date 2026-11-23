class Voter(final int id) implements Comparable<Voter> {
  this : assert(id >= 0);

  @override
  int compareTo(Voter other) => id.compareTo(other.id);

  @override
  bool operator ==(Object other) => other is Voter && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
