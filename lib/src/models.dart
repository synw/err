import 'package:err/err.dart';

import 'types.dart';

/// An error
class Err {
  /// The error debug message
  final String userMessage;

  /// The date of the error
  DateTime get date => _date;

  /// The error type
  ErrType get type => _type;

  /// Get an exception from the message
  Exception get exception => Exception(_message);

  /// Get the message
  String get message => _message;

  /// Is the error empty
  bool get isNil => _isNil;

  /// Is the error empty
  bool get isNotNil => !_isNil;

  final DateTime _date;
  final ErrType _type;
  final bool _isNil;
  final String _message;
  final Error _error;

  // **************************
  //        Constructors
  // **************************

  /// Critical constructor
  ///
  /// Provide a message or an exception
  /// and optionaly provide the [function] that caused
  /// the error. The [date] of the error is automatically set
  Err.critical(dynamic e, {this.userMessage})
      : assert(e != null),
        _type = ErrType.critical,
        _date = DateTime.now(),
        _isNil = false,
        _message = _getMessageFromInput(e),
        _error = _getError(e);

  /// Error constructor
  ///
  /// Provide a message or an exception
  /// and optionaly provide the [function] that caused
  /// the error. The [date] of the error is automatically set
  Err.error(dynamic e, {this.userMessage})
      : assert(e != null),
        _type = ErrType.error,
        _date = DateTime.now(),
        _isNil = false,
        _message = _getMessageFromInput(e),
        _error = _getError(e);

  /// Warning constructor
  ///
  /// Provide a message or an exception
  /// and optionaly provide the [function] that caused
  /// the error. The [date] of the error is automatically set
  Err.warning(dynamic e, {this.userMessage})
      : assert(e != null),
        _type = ErrType.warning,
        _date = DateTime.now(),
        _isNil = false,
        _message = _getMessageFromInput(e),
        _error = _getError(e);

  /// Info constructor
  ///
  /// Provide a message or an exception
  /// and optionaly provide the [function] that caused
  /// the error. The [date] of the error is automatically set
  Err.info(dynamic e, {this.userMessage})
      : assert(e != null),
        _type = ErrType.info,
        _date = DateTime.now(),
        _isNil = false,
        _message = _getMessageFromInput(e),
        _error = _getError(e);

  /// Debug constructor
  ///
  /// Provide a message or an exception
  /// and optionaly provide the [function] that caused
  /// the error. The [date] of the error is automatically set
  Err.debug(dynamic e, {this.userMessage})
      : assert(e != null),
        _type = ErrType.debug,
        _date = DateTime.now(),
        _isNil = false,
        _message = _getMessageFromInput(e),
        _error = _getError(e);

  /// Build an error from an [ErrType] and message or exception
  Err.fromType(dynamic e, ErrType errType, {this.userMessage, DateTime date})
      : assert(e != null),
        assert(errType != null),
        _type = errType,
        _date = date ?? DateTime.now(),
        _isNil = false,
        _message = _getMessageFromInput(e),
        _error = _getError(e);

  /// An empty error
  const Err.nil()
      : _type = null,
        _date = null,
        _message = null,
        _error = null,
        userMessage = null,
        _isNil = true;

  // **************************
  //         Methods
  // **************************

  /// Duplicate with a new user message
  Err copyWithUserMessage(String _userMessage) =>
      Err.fromType(exception, type, userMessage: _userMessage, date: date);

  /// Print this error to the console
  void console() => _consoleLog();

  /// Throw an exception from this error
  void raise() => throw exception;

  /// Throw an exception if an error is present
  void throwIfNotNil() {
    if (isNotNil) {
      raise();
    }
  }

  /// Log the to console if an error is present
  void logIfNotNil() {
    if (isNotNil) {
      _consoleLog();
    }
  }

  /// Static method to print an error or message to the console
  static void log(dynamic err) {
    if (err is Err) {
      err.console();
    } else {
      Err.debug("$err").console();
    }
  }

  @override
  String toString() => "$date : $_message";

  // **************************
  //      Private methods
  // **************************

  static String _getMessageFromInput(dynamic e) {
    String _msg;
    if (e is Exception) {
      _msg = "$e";
    } else if (e is String) {
      _msg = e;
    } else if (e is Error) {
      _msg = "$e";
    } else {
      throw ArgumentError(
          "Please provide either and exception, an error or a message");
    }
    return _msg;
  }

  static Error _getError(dynamic _e) {
    Error _er;
    if (_e is Error) {
      _er = _e;
    }
    return _er;
  }

  void _consoleLog() => print(_formatMsg());

  String _formatMsg() {
    String msg;
    const bar = "➖➖➖➖➖➖➖➖";
    switch (type) {
      case ErrType.critical:
        const icon = "🔴";
        msg = "$bar\n$icon CRITICAL: $_message";
        if (_error != null) {
          msg += "\n${_error.stackTrace}";
        } else {
          msg += "\n";
        }
        msg += "$bar";
        break;
      case ErrType.error:
        const icon = "⭕";
        msg = "$bar\n$icon ERROR: $_message";
        if (_error != null) {
          msg += "\n${_error.stackTrace}";
        } else {
          msg += "\n";
        }
        msg += "$bar";
        break;
      case ErrType.warning:
        const icon = "❗";
        msg = "$icon WARNING: $_message";
        break;
      case ErrType.info:
        const icon = "ℹ️";
        msg = "$icon  INFO: $_message";
        break;
      case ErrType.debug:
        const icon = "🔔";
        msg = "$icon DEBUG: $_message";
        if (_error != null) {
          msg += "\n${_error.stackTrace}";
        }
        break;
      default:
        msg = "$_message";
    }
    return msg;
  }
}

/// A typed return value with an error slot
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
  void log() => err._consoleLog();

  /// Throw an exception from the [Err]
  void raise() => err.raise();

  /// Throw an exception if an error is present
  void throwIfError() {
    if (hasError) {
      err.raise();
    }
  }
}
