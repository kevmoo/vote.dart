// Called by https://pub.dartlang.org/packages/peanut

import 'dart:io';

import 'package:path/path.dart' as p;

void main(List<String> args) {
  final buildDir = args[0];

  File(p.join(buildDir, 'CNAME')).writeAsStringSync('vote.j832.com\n');
}
