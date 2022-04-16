import 'dart:io';

import 'package:action_bloc_example/main.dart';

void main(List<String> arguments) {
  int? limit;

  if (arguments.isNotEmpty) {
    limit = int.tryParse(arguments.first);
  }

  do {
    stdout.writeln('Input limit:');
    limit = int.tryParse(stdin.readLineSync() ?? '');
  } while (limit == null);

  run(limit);
}
