import 'package:err/err.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:enum_to_string/enum_to_string.dart';

import '../types.dart';

Box<Map<dynamic, dynamic>> _box;

/// An error
@immutable
class Err {
  /// The error debug message
  final String userMessage;

  /// Get the message
  String get message => _message;

  /// The date of the error
  DateTime get date => _date;

  /// The error type
  ErrType get type => _type;

  /// Get an exception from the message
  Exception get exception => Exception(_message);

  /// Is the error empty
  bool get isNil => _isNil;

  /// Is the error empty
  bool get isNotNil => !_isNil;

  final DateTime _date;
  final ErrType _type;
  final bool _isNil;
  final String _message;
  final Error _error;

  bool get _storeData => _box != null;

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
        _error = _getError(e) {
    if (_storeData) {
      _box.add(toJson());
    }
  }

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
        _error = _getError(e) {
    if (_storeData) {
      _box.add(toJson());
    }
  }

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
        _error = _getError(e) {
    if (_storeData) {
      _box.add(toJson());
    }
  }

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
        _error = _getError(e) {
    if (_storeData) {
      _box.add(toJson());
    }
  }

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
        _error = _getError(e) {
    if (_storeData) {
      _box.add(toJson());
    }
  }

  /// Build an error from an [ErrType] and message or exception
  Err.fromType(dynamic e, ErrType errType,
      {this.userMessage, DateTime date, bool disableStorage = false})
      : assert(e != null),
        assert(errType != null),
        _type = errType,
        _date = date ?? DateTime.now(),
        _isNil = false,
        _message = _getMessageFromInput(e),
        _error = _getError(e) {
    if (_storeData && !disableStorage) {
      _box.add(toJson());
    }
  }

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
  Err copyWithUserMessage(String _userMessage) => Err.fromType(exception, type,
      userMessage: _userMessage, date: date, disableStorage: true);

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

  /// Json serializer
  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        "message": message,
        "date": date.millisecondsSinceEpoch,
        "type": EnumToString.parse(type),
        "user_message": userMessage,
      };

  /// Json deserializer
  factory Err.fromJson(Map<dynamic, dynamic> map) => Err.fromType(
      map["message"].toString(),
      EnumToString.fromString(ErrType.values, map["type"].toString()),
      date: DateTime.fromMillisecondsSinceEpoch(
          int.parse(map["date"].toString())),
      userMessage: map["user_message"].toString());

  /// Static method to print an error or message to the console
  static void log(dynamic err) {
    if (err is Err) {
      err.console();
    } else {
      Err.debug("$err").console();
    }
  }

  // ********** storage **********

  /// Configure the storage
  static Future<void> enableStorage(
      {Box<Map<dynamic, dynamic>> box, String storagePath}) async {
    if (box == null && storagePath == null) {
      throw ArgumentError("Provide either a box or a storage path");
    }
    var b = box;
    if (box == null) {
      Hive.init(storagePath);
      b = await Hive.openBox<Map<dynamic, dynamic>>("err");
    }
    _box = b;
  }

  /// Clear the storage
  static Future<void> clearStorage() async {
    assert(_box != null);
    await _box.clear();
  }

  /// Select the last n errs from storage
  static Future<List<Err>> select({int number = 30}) async {
    assert(_box != null);
    final errs = <Err>[];
    final len = _box.keys.length;
    final start = ((number - 1) > len) ? 0 : (number - 1) - len;
    _box
        .valuesBetween(startKey: start, endKey: len - 1)
        .forEach((v) => errs.add(Err.fromJson(v)));
    return errs;
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
