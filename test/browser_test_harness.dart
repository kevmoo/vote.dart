library vote.browser_test_harness;

import 'package:unittest/html_enhanced_config.dart';

import 'console_test_harness.dart' as console;

void main() {
  useHtmlEnhancedConfiguration();

  console.main();
}
