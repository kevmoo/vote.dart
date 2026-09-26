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

  group('allUnique', () {
    test('empty list is unique', () {
      expect(<int>[].allUnique, isTrue);
    });

    test('single element is unique', () {
      expect([1].allUnique, isTrue);
    });

    test('distinct elements are unique', () {
      expect([1, 2, 3].allUnique, isTrue);
    });

    test('duplicate elements return false', () {
      expect([1, 2, 1].allUnique, isFalse);
    });
  });
}
