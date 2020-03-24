import 'package:meta/meta.dart';

import 'err.dart';

/// A typed return value with an error slot
@immutable
class ErrPack<T> {
  /// The return value
  final T value;

  /// The error
  final Err err;

  /// Check if there is an error
  bool get hasError {
    if (err != null) {
      if (err.isNil) {
        return false;
      }
    } else {
      return false;
    }
    return true;
  }

  /// Constructor for a return value without error
  const ErrPack.ok(this.value)
      : assert(value != null),
        err = const Err.nil();

  /// Constructor for a null return value without error
  const ErrPack.nullOk()
      : value = null,
        err = const Err.nil();

  /// Constructor for a return error
  const ErrPack.err(this.err)
      : assert(err != null),
        value = null;

  /// Print the error to the console
  void log() => err.console();

  /// Throw an exception from the [Err]
  void raise() => err.raise();

  /// Throw an exception if an error is present
  void throwIfError() {
    if (hasError) {
      err.raise();
    }
  }
}
