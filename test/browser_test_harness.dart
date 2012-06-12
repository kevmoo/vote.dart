#import('../vendor/unittest/html_config.dart');

#import('core/_core_runner.dart');
#import('experimental/_experimental_runner.dart');
#import('vote/_vote_runner.dart');

main() {
  useHtmlConfiguration();

  runCoreTests();
  runExperimentalTests();
  runVoteTests();
}
