import 'package:err/err.dart';

void _someErrs() {
  final e = Err.error("An error message");
  final w = Err.warning("A warning message");
  final i = Err.info("An info message");
  final d = Err.debug("A debug message");
  // print
  e.console();
  i.console();
  d.console();
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
