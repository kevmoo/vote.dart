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
}
