import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

import 'console.dart';
import 'log.dart';
import 'models.dart';
import 'types.dart';

/// The error router
class ErrRouter {
  /// The main constructor: provide the [deployementMode]
  ErrRouter(this.deployementMode)
      : assert(deployementMode != null),
        _logger =
            Logger(printer: ConsolePrinter(methodCount: 8, skipMethods: 3));

  /// The app deployement mode
  DeployementMode deployementMode;

  final ErrLogger _errLogger = ErrLogger();
  final int _maxDeviceConsoleMessages = 100;
  final Logger _logger;
  //final _messages = <String>[];

  /// The [Err] log history
  List<Err> get history => _errLogger.errs;

  /// Print an error to the console
  ///
  /// If [err] is not an [Err] it will be
  /// translated to a string as the message.
  /// Provide a [String] to just display a message
  void console(dynamic err) {
    switch (err is Err) {
      case true:
        final _err = err as Err;
        _dispatch(_err.type,
            userMsg: _err.userMessage,
            msg: _err.message,
            errorOrException: _err.errorOrException);
        _addErrToErrLogger(_err);
        break;
      default:
        final _msg = "$err";
        _dispatch(ErrType.debug, msg: _msg);
        _addStringToErrLogger(_msg, ErrType.debug);
    }
  }

  /// Display this [Err] to the user screen (flushbar)
  ///
  /// If [err] is not an [Err] it will be
  /// translated to a string as the message.
  /// Provide a [String] to just display a message
  void screen(dynamic err, BuildContext context) {
    assert(err != null);
    switch (err is Err) {
      case true:
        final _err = err as Err;
        _dispatch(_err.type,
            msg: _err.message,
            userMsg: _err.userMessage,
            errorOrException: err.errorOrException,
            toScreen: true,
            context: context);
        _addErrToErrLogger(_err);
        break;
      default:
        final _msg = "$err";
        _dispatch(ErrType.info, msg: _msg, toScreen: true, context: context);
        _addStringToErrLogger(_msg, ErrType.info);
    }
  }

  /// Flash this [Err] to the user screen (toast)
  ///
  /// If [err] is not an [Err] it will be
  /// translated to a string as the message.
  /// Provide a [String] to just display a message
  /// Limitations: this method only works for mobile
  void flash(dynamic err) {
    switch (err is Err) {
      case true:
        final _err = err as Err;
        _dispatch(_err.type,
            msg: _err.message,
            userMsg: _err.userMessage,
            errorOrException: err.errorOrException,
            toScreen: true,
            flash: true);
        _addErrToErrLogger(_err);
        break;
      default:
        final _msg = "$err";
        _dispatch(ErrType.info, msg: _msg, toScreen: true, flash: true);
        _addStringToErrLogger(_msg, ErrType.info);
    }
  }

  // ********************************
  //        Private methods
  // ********************************

  void _addErrToErrLogger(Err err) => _errLogger.add(err);

  void _addStringToErrLogger(String msg, ErrType errType) =>
      _errLogger.add(Err.fromType(msg, errType));

  void _dispatch(ErrType _errType,
      {BuildContext context,
      String msg,
      String userMsg,
      dynamic errorOrException,
      bool short = false,
      bool flash = false,
      int timeOnScreen = 1,
      bool toScreen = false}) {
    final _errMsg = _getErrMessage(
      msg,
      errorOrException,
    );
    var logToConsole = true;
    switch (deployementMode) {
      case DeployementMode.production:
        if (_errType == ErrType.debug) {
          return;
        }
        logToConsole = false;
        break;
      default:
    }
    // log to history
    _errLogger.errs.insert(
        0, Err.fromType(msg, _errType, errorOrException: errorOrException));
    if (_errLogger.errs.length > _maxDeviceConsoleMessages) {
      _errLogger.errs.removeLast();
    }
    // console log
    if (logToConsole) {
      _consoleLog(_errType, _errMsg);
    }
    // screen log
    if (toScreen) {
      var msg = _errMsg;
      if (userMsg != null) {
        msg = userMsg;
      }
      final err = _buildScreenMessage(_errType, msg, errorOrException,
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
    Flushbar flush;
    flush = Flushbar(
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
      mainButton: FlatButton(
        child: const Text("Ok"),
        onPressed: () => flush.dismiss(true),
      ),
    );
    return flush;
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
