import 'package:test/test.dart';
import 'package:vote/src/util.dart';

void main() {
  test('majority threshold', () {
    expect(majorityThreshold(5), 3);
    expect(majorityThreshold(4), 3);
    expect(majorityThreshold(49), 25);
    expect(majorityThreshold(50), 26);
    expect(majorityThreshold(51), 26);
  });

  group('sorted', () {
    const items = <List<int>, bool>{
      []: true,
      [1]: true,
      [1, 2]: true,
      [1, 2, 3]: true,
      [2, 1]: false,
      [2, 2]: true,
      [0, 2, 1]: false,
    };

    for (var entry in items.entries) {
      test(entry.key.toString(), () {
        expect(sorted(entry.key), entry.value);
      });
    }
  });
}
