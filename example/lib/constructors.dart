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
  // throw
  print("A problem occurs");
  try {
    final l = <int>[];
    print(l[1]);
  } catch (e) {
    Err.critical(e)
      ..console()
      ..raise();
  }
}

void main() {
  try {
    _someErrs();
  } catch (e) {
    Err.log("Rethrowing exception:");
    rethrow;
  }
}
