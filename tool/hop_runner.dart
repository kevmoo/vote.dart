import 'dart:io';

import 'package:bot/bot.dart';
import 'package:hop/hop.dart';

import '../test/console_test_harness.dart' as test_console;

void main() {
  _assertKnownPath();

  addAsyncTask('test', getTestRunner(test_console.testCore));

  //
  // Dart2js
  //
  final paths = const ['web/vote_demo.dart', 'test/browser_test_harness.dart'];

  addAsyncTask('dart2js', getDart2jsTask(paths));
  runHopCore();
}

void _assertKnownPath() {
  // since there is no way to determine the path of 'this' file
  // assume that Directory.current() is the root of the project.
  // So check for existance of /bin/hop_runner.dart
  final thisFile = new File('tool/hop_runner.dart');
  assert(thisFile.existsSync());
}
