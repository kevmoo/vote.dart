import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'src/vote_simulation.dart';

void main() {
  setUrlStrategy(PathUrlStrategy());
  runApp(const VoteSimulation());
}
