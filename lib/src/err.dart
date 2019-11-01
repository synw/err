import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

import 'console.dart';
import 'types.dart';

/// The error router
class ErrRouter {
  /// The main constructor: provide the [channel]
  ErrRouter({
    @required this.channel,
    this.deviceConsole = false,
    this.maxDeviceConsoleMessages = 100,
  }) : _logger =
            Logger(printer: ConsolePrinter(methodCount: 8, skipMethods: 3));

  /// The error channel
  ErrChannel channel;

  /// Use the on device console
  bool deviceConsole;

  /// The maximum number of messages for the on device console
  int maxDeviceConsoleMessages;

  final Logger _logger;
  final _messages = <String>[];

  /// The logged messages for device console
  List<String> get messages => _messages;

  /// A critical error
  ///
  /// An error or exception can be passed to [err]
  Future<void> critical(String msg, {dynamic err}) async {
    if (msg == null) {
      throw ArgumentError.notNull();
    }
    _dispatch(ErrType.critical, msg: msg, errorOrException: err);
  }

  /// A critical error
  ///
  /// Will stay on screen until dismissed.
  /// An error or exception can be passed to [err]
  Future<void> criticalScreen(String msg,
      {@required BuildContext context, dynamic err}) async {
    if (msg == null) {
      throw ArgumentError.notNull();
    }
    _dispatch(ErrType.critical,
        msg: msg, errorOrException: err, toScreen: true, context: context);
  }

  /// An error message
  Future<void> error(String msg, {dynamic err}) async {
    /// An error or exception can be passed to [err]
    if (msg == null) {
      throw ArgumentError.notNull();
    }
    _dispatch(ErrType.error, msg: msg, errorOrException: err);
  }

  /// An error message
  ///
  /// Will stay on screen until dismissed.
  /// An error or exception can be passed to [err]
  Future<void> errorScreen(String msg,
      {@required BuildContext context, dynamic err}) async {
    if (msg == null) {
      throw ArgumentError.notNull();
    }
    _dispatch(ErrType.error,
        msg: msg, errorOrException: err, context: context, toScreen: true);
  }

  /// A flash error message.
  ///
  /// Will stay on screen for 5 seconds
  Future<void> errorFlash(String msg) async {
    if (msg == null) {
      throw ArgumentError.notNull();
    }
    _dispatch(ErrType.error,
        msg: msg, toScreen: true, flash: true, timeOnScreen: 5);
  }

  /// A warning from a message.
  ///
  /// An error or exception can be passed to [err]
  Future<void> warning(String msg, {dynamic err}) async {
    if (msg == null) {
      throw ArgumentError.notNull();
    }
    _dispatch(ErrType.warning, msg: msg, errorOrException: err);
  }

  /// A warning from a message.
  ///
  /// Will stay on the screen until dismissed
  /// A [context] has to be provided for the message to print on device screen
  /// If [short] is true it will stay on screen only for 3 seconds, if false
  /// it will stay until dismissed. An error or exception can be passed
  /// to [err]
  Future<void> warningScreen(String msg,
      {@required BuildContext context, dynamic err, bool short = true}) async {
    if (msg == null) {
      throw ArgumentError.notNull();
    }
    _dispatch(ErrType.warning,
        msg: msg,
        errorOrException: err,
        short: short,
        toScreen: true,
        context: context);
  }

  /// A warning flash message.
  ///
  /// Will stay on screen for 3 seconds
  Future<void> warningFlash(String msg) async {
    if (msg == null) {
      throw ArgumentError.notNull();
    }
    _dispatch(ErrType.warning,
        msg: msg, toScreen: true, flash: true, timeOnScreen: 3);
  }

  /// An info message.
  Future<void> info(String msg) async {
    if (msg == null) {
      throw ArgumentError.notNull();
    }
    _dispatch(ErrType.info, msg: msg);
  }

  /// An info message.
  ///
  /// A [context] has to be provided for the message to print on device screen
  /// If [short] is true it will stay on screen only for 3 seconds, if false
  /// it will stay until dismissed
  Future<void> infoScreen(String msg,
      {@required BuildContext context, bool short = true}) async {
    if (msg == null) {
      throw ArgumentError.notNull();
    }
    if (context == null) {
      throw ArgumentError.notNull();
    }
    _dispatch(ErrType.info,
        msg: msg, short: short, toScreen: true, context: context);
  }

  /// An info flash message.
  ///
  /// Will stay on the screen for 1 second
  Future<void> infoFlash(String msg) async {
    if (msg == null) {
      throw ArgumentError.notNull();
    }
    _dispatch(ErrType.info, msg: msg, toScreen: true, flash: true);
  }

  /// An debug message
  Future<void> debug(String msg, {dynamic err}) async {
    /// An error or exception can be passed to [err]
    if (msg == null) {
      throw ArgumentError.notNull();
    }
    _dispatch(ErrType.debug, msg: msg, errorOrException: err);
  }

  /// An debug message sent to the screen
  ///
  /// An error or exception can be passed to [err]. Will stay until dismissed
  /// or if [short] is true it will stay for 3 seconds on screen
  Future<void> debugScreen(String msg,
      {@required BuildContext context, dynamic err, bool short = false}) async {
    if (msg == null) {
      throw ArgumentError.notNull();
    }
    _dispatch(ErrType.debug,
        msg: msg,
        short: short,
        toScreen: true,
        context: context,
        errorOrException: err);
  }

  /// An debug flash message from a message.
  ///
  /// Will stay on the screen for 1 second
  Future<void> debugFlash(String msg) async {
    if (msg == null) {
      throw ArgumentError.notNull();
    }
    _dispatch(ErrType.debug, toScreen: true, msg: msg, flash: true);
  }

  /// An alias for infoFlash
  Future<void> flash(String msg) => infoFlash(msg);

  void _dispatch(ErrType _errType,
      {BuildContext context,
      String msg,
      dynamic errorOrException,
      bool short = false,
      bool flash = false,
      int timeOnScreen = 1,
      bool toScreen = false}) {
    if (channel == ErrChannel.production) {
      if (_errType == ErrType.debug) {
        return;
      }
    }
    final _errMsg = _getErrMessage(
      msg,
      errorOrException,
    );
    if (deviceConsole) {
      _messages.insert(0, _formatErrMsg(_errType, _errMsg));
      if (_messages.length > maxDeviceConsoleMessages) {
        _messages.removeLast();
      }
    }
    if (channel == ErrChannel.dev) {
      _consoleLog(_errType, _errMsg);
    }
    if (toScreen) {
      final err = _buildScreenMessage(_errType, _errMsg, errorOrException,
          short: short, flash: flash, timeOnScreen: timeOnScreen);
      _popMsg(err: err, context: context);
    }
  }

  _Err _buildScreenMessage(
      ErrType _errType, String _errMsg, dynamic _errorOrException,
      {bool short = false, bool flash = false, int timeOnScreen}) {
    switch (flash) {
      case true:
        final colors = _getColors(_errType);
        return _Err(
            msg: _errMsg,
            type: _errType,
            toast: _ShortToast(
                errMsg: _errMsg,
                timeOnScreen: timeOnScreen,
                backgroundColor: colors["background_color"],
                textColor: colors["text_color"]));
    }
    return _Err(
        msg: _errMsg,
        type: _errType,
        flushbar: _buildFlushbar(_errType, _errMsg, short: short));
  }

  void _popMsg({_Err err, BuildContext context}) {
    switch (err.flushbar != null) {
      case true:
        err.show(context);
        break;
      default:
        err.show();
    }
  }

  void _consoleLog(ErrType _errType, String _errMsg) {
    switch (_errType) {
      case ErrType.critical:
        _logger.wtf(_errMsg);
        break;
      case ErrType.error:
        _logger.e(_errMsg);
        break;
      case ErrType.warning:
        _printErr(ErrType.warning, _errMsg);
        break;
      case ErrType.info:
        _printErr(ErrType.info, _errMsg);
        break;
      case ErrType.debug:
        _printErr(ErrType.debug, _errMsg);
        break;
    }
  }

  void _printErr(ErrType _errType, String _errMsg) =>
      print(_formatErrMsg(_errType, _errMsg));

  String _formatErrMsg(ErrType _errType, String _errMsg) {
    String msg;
    switch (_errType) {
      case ErrType.critical:
        final hasBar = _errMsg.length > 65 || _errMsg.contains("\n");
        String endStr;
        hasBar ? endStr = "\n➖➖➖➖➖➖➖➖" : endStr = "";
        const icon = "🔴";
        msg = "$icon CRITICAL: $_errMsg$endStr";
        break;
      case ErrType.error:
        final hasBar = _errMsg.length > 65 || _errMsg.contains("\n");
        String endStr;
        const icon = "⭕";
        hasBar ? endStr = "\n➖➖➖➖➖➖➖➖" : endStr = "";
        msg = "$icon ERROR: $_errMsg$endStr";
        break;
      case ErrType.warning:
        const icon = "❗";
        msg = "$icon WARNING: $_errMsg";
        break;
      case ErrType.info:
        const icon = "ℹ️";
        msg = "$icon INFO: $_errMsg";
        break;
      case ErrType.debug:
        const icon = "🔔";
        msg = "$icon DEBUG: $_errMsg";
        break;
      default:
        msg = "$_errMsg";
    }
    return msg;
  }

  Flushbar _buildFlushbar(ErrType _errType, String _errMsg,
      {bool short = false}) {
    final colors = _getColors(_errType);
    IconData _icon;
    final _backgroundColor = colors["background_color"];
    var _iconColor = Colors.white;
    Color _leftBarIndicatorColor;
    final _textColor = colors["text_color"];
    switch (_errType) {
      case ErrType.critical:
        _icon = Icons.error;
        _iconColor = Colors.red;
        _leftBarIndicatorColor = Colors.red;
        break;
      case ErrType.error:
        _icon = Icons.error_outline;
        _leftBarIndicatorColor = Colors.black;
        break;
      case ErrType.warning:
        _icon = Icons.warning;
        _leftBarIndicatorColor = Colors.black;
        break;
      case ErrType.info:
        _icon = Icons.info;
        break;
      case ErrType.debug:
        _icon = Icons.bug_report;
        _leftBarIndicatorColor = Colors.black;
        break;
    }
    return Flushbar(
      duration: short ? const Duration(seconds: 5) : const Duration(days: 365),
      icon: Icon(
        _icon,
        color: _iconColor,
        size: 35.0,
      ),
      leftBarIndicatorColor: _leftBarIndicatorColor,
      backgroundColor: _backgroundColor,
      messageText: Text(
        _errMsg,
        style: TextStyle(color: _textColor),
      ),
      titleText: Text(
        _getErrTypeString(_errType),
        style: TextStyle(color: _textColor),
        textScaleFactor: 1.6,
      ),
      isDismissible: true,
    );
  }

  Map<String, Color> _getColors(ErrType _errType) {
    var _backgroundColor = Colors.black;
    var _textColor = Colors.white;
    switch (_errType) {
      case ErrType.critical:
        _backgroundColor = Colors.black;
        break;
      case ErrType.error:
        _backgroundColor = Colors.red;
        break;
      case ErrType.warning:
        _backgroundColor = Colors.deepOrange;
        break;
      case ErrType.info:
        _backgroundColor = Colors.lightBlueAccent;
        _textColor = Colors.black;
        break;
      case ErrType.debug:
        _backgroundColor = Colors.purple;
        break;
    }
    return {
      "background_color": _backgroundColor,
      "text_color": _textColor,
    };
  }

  String _getErrMessage(String _message, dynamic _errorOrException) {
    var _endMsg = "";
    if (_message != null) {
      _endMsg = _message;
      if (_errorOrException != null) _endMsg += "\n\n";
    }
    if (_errorOrException != null) _endMsg += "$_errorOrException";
    return _endMsg;
  }

  String _getErrTypeString(ErrType _errType) {
    String type;
    switch (_errType) {
      case ErrType.critical:
        type = "Critical";
        break;
      case ErrType.error:
        type = "Error";
        break;
      case ErrType.warning:
        type = "Warning";
        break;
      case ErrType.info:
        type = "Info";
        break;
      case ErrType.debug:
        type = "Debug";
        break;
    }
    return type;
  }
}

class _Err {
  _Err({@required this.msg, @required this.type, this.flushbar, this.toast});

  final Flushbar flushbar;
  final _ShortToast toast;
  final String msg;
  final ErrType type;

  /// The show method to pop the message on screen if needed.
  ///
  /// A [BuildContext] is required only for [Flushbar] messages,
  /// not the flash messages that use [Toast]
  void show([BuildContext context]) {
    if (toast != null) {
      toast.show();
      return;
    }
    if (flushbar != null) {
      if (context == null) {
        throw ArgumentError(
            "Pass the context to show if you use anything other "
            "than flash messages");
      }
      flushbar.show(context);
      return;
    }
  }
}

class _ShortToast {
  _ShortToast(
      {@required this.backgroundColor,
      @required this.textColor,
      @required this.errMsg,
      this.timeOnScreen});

  final Color backgroundColor;
  final Color textColor;
  final String errMsg;
  final int timeOnScreen;

  void show([BuildContext _]) {
    Fluttertoast.showToast(
        msg: errMsg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: timeOnScreen,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: 16.0);
  }
}
