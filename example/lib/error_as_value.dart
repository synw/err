import 'package:err/err.dart';

ErrPack<int> _someFunctionThatReturnsAnInt() {
  try {
    throw Exception("Oops");
  } catch (e) {
    // return an error and no value
    return ErrPack.err(Err.warning(e));
  }
  // return no error and a integer value
  return const ErrPack.ok(1);
}

ErrPack<Null> _someFunctionThatReturnsNull() {
  try {
    // ok
  } catch (e) {
    // return an error and no value
    return ErrPack.err(Err.debug("Something went wrong"));
  }
  // return no error and a null value
  return const ErrPack.nullOk();
}

void main() {
  _someFunctionThatReturnsNull().throwIfError();
  // or
  final res = _someFunctionThatReturnsAnInt();
  if (res.hasError) {
    print("- This function returns an error:");
    res.err.console();
  }
  // or
  print("- Throw the error returned by the function:");
  _someFunctionThatReturnsAnInt().throwIfError();
  // get the return value
  final int i = res.value;
}
