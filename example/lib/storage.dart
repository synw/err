import 'package:err/err.dart';

void _someErrs() {
  final e = Err.error("An error message");
  final w = Err.warning("A warning message");
  final i = Err.info("An info message");
  final d = Err.debug("A debug message");
  // print
  print("Some message");
  e.console();
  print("Some other message");
  i.console();
  print("Some other message");
  d.console();
  print("Some other message");
  w.console();
}

Future<void> main() async {
  await Err.enableStorage(storagePath: "./data");
  // reset the data
  await Err.clearStorage();
  // generate some errors
  _someErrs();
  // read storage
  print("Reading from storage:");
  final errs = await Err.select();
  errs.forEach(print);
}
