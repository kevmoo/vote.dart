import 'package:flutter/widgets.dart';

import 'src/my_platform.dart' if (dart.library.html) 'src/my_platform_web.dart';
import 'src/vote_simulation.dart';

void main() {
  configurePlatform();
  runApp(VoteSimulation());
}
