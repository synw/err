import 'package:err/err.dart';
import 'package:flutter/material.dart';

import 'types.dart';

/// An error
class Err {
  /// The error message
  final String message;

  /// The error debug message
  final String userMessage;

  /// The function from where the error comes from
  final Function function;

  /// An error or exception
  final dynamic errorOrException;

  /// The date of the error
  DateTime get date => _date;

  /// The error type
  ErrType get type => _type;

  /// Is the error empty
  bool get isNil => _isNil;

  final DateTime _date;
  final ErrType _type;
  final bool _isNil;

  /// Critical constructor
  ///
  /// Provide a [message] , optionally an [Error] or [Exception]
  /// and optionaly provide the [function] that caused
  /// the error. The [date] of the error is automatically set
  Err.critical(this.message,
      {this.userMessage, this.errorOrException, this.function})
      : assert(message != null),
        _type = ErrType.critical,
        _date = DateTime.now(),
        _isNil = false;

  /// Error constructor
  ///
  /// Provide a [message] , optionally an [Error] or [Exception]
  /// and optionaly provide the [function] that caused
  /// the error. The [date] of the error is automatically set
  Err.error(this.message,
      {this.userMessage, this.errorOrException, this.function})
      : assert(message != null),
        _type = ErrType.error,
        _date = DateTime.now(),
        _isNil = false;

  /// Warning constructor
  ///
  /// Provide a [message] , optionally an [Error] or [Exception]
  /// and optionaly provide the [function] that caused
  /// the error. The [date] of the error is automatically set
  Err.warning(this.message,
      {this.userMessage, this.errorOrException, this.function})
      : assert(message != null),
        _type = ErrType.warning,
        _date = DateTime.now(),
        _isNil = false;

  /// Info constructor
  ///
  /// Provide a [message] , optionally an [Error] or [Exception]
  /// and optionaly provide the [function] that caused
  /// the error. The [date] of the error is automatically set
  Err.info(this.message,
      {this.userMessage, this.errorOrException, this.function})
      : assert(message != null),
        _type = ErrType.info,
        _date = DateTime.now(),
        _isNil = false;

  /// Debug constructor
  ///
  /// Provide a [message] , optionally an [Error] or [Exception]
  /// and optionaly provide the [function] that caused
  /// the error. The [date] of the error is automatically set
  Err.debug(this.message,
      {this.userMessage, this.errorOrException, this.function})
      : assert(message != null),
        _type = ErrType.debug,
        _date = DateTime.now(),
        _isNil = false;

  /// Build an error from an [ErrType] and message
  Err.fromType(this.message, ErrType errType,
      {this.userMessage,
      this.errorOrException,
      this.function,
      DateTime dateTime})
      : assert(message != null),
        assert(errType != null),
        _type = errType,
        _date = dateTime ?? DateTime.now(),
        _isNil = false;

  /// An empty error
  const Err.nil()
      : _type = null,
        _date = null,
        function = null,
        errorOrException = null,
        userMessage = null,
        message = null,
        _isNil = true;

  /// Duplicate with a new user message
  factory Err.duplicateWithUserMessage(Err err, String _userMessage) =>
      Err.fromType(err.message, err.type,
          userMessage: _userMessage,
          function: err.function,
          errorOrException: err.errorOrException,
          dateTime: err.date);

  /// Push the error to the screen if it exists
  void catchToScreen(ErrRouter router, BuildContext context) {
    if (message != null) {
      router.screen(this, context);
    }
  }

  @override
  String toString() {
    var msg = "$date : $message";
    if (function != null) {
      msg += " from $function";
    }
    return msg;
  }
}

/// A typed return value with an eror slot
class ErrPack<T> {
  /// Default constructor
  //const ErrPack(this.err, this.value);

  /// Construtor for a return without error
  const ErrPack.ok(this.value) : err = const Err.nil();

  /// Construtor for a return without error
  const ErrPack.error(this.err) : value = null;

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

  /// Push the error to the screen if it exists
  void catchToScreen(ErrRouter router, BuildContext context) {
    if (hasError) {
      router.screen(err, context);
    }
  }
}
