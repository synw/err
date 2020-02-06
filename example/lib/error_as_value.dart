import 'package:err/err.dart';

ErrPack<int> _someFunctionThatReturnsAnInt() {
  try {
    throw Exception("Oops");
  } catch (e) {
    return ErrPack.err(Err.warning(e));
  }
  return const ErrPack.ok(1);
}

ErrPack _someFunctionThatReturnsNull() {
  try {
    // ok
  } catch (e) {
    return ErrPack.err(Err.debug(e));
  }
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
