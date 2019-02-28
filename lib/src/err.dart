import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// The route types
enum ErrRoute { console, screen, blackHole }

/// The error types
enum ErrType { critical, error, warning, info, debug }

/// The error router
class ErrRouter {
  ErrRouter(
      {this.criticalRoute,
      this.errorRoute,
      this.warningRoute,
      this.infoRoute,
      this.debugRoute,
      this.terminalColors = false}) {
    criticalRoute = criticalRoute ?? [ErrRoute.console];
    errorRoute = errorRoute ?? [ErrRoute.console];
    warningRoute = warningRoute ?? [ErrRoute.console];
    infoRoute = infoRoute ?? [ErrRoute.console];
    debugRoute = debugRoute ?? [ErrRoute.console];
    _errorRoutes = {
      ErrType.critical: criticalRoute,
      ErrType.error: errorRoute,
      ErrType.warning: warningRoute,
      ErrType.info: infoRoute,
      ErrType.debug: debugRoute,
    };
  }

  List<ErrRoute> criticalRoute;
  List<ErrRoute> errorRoute;
  List<ErrRoute> warningRoute;
  List<ErrRoute> infoRoute;
  List<ErrRoute> debugRoute;
  bool terminalColors;

  Map<ErrType, List<ErrRoute>> _errorRoutes;

  /// A critical error. Will stay on screen until dismissed. Needs a context
  /// to be shown on screen
  Future<Err> critical({String msg, dynamic errorOrException}) async {
    if (msg == null && errorOrException == null)
      throw ArgumentError(
          "You must provide either an errorOrException or a msg to build a critical msg");
    ErrType _errType = ErrType.critical;
    return _dispatch(_errType, msg, errorOrException);
  }

  /// An error. Will stay on screen until dismissed. Needs a context
  /// to be shown on screen
  Future<Err> error({String msg, dynamic errorOrException}) async {
    if (msg == null && errorOrException == null)
      throw ArgumentError(
          "You must provide either an errorOrException or a msg to build an error");
    ErrType _errType = ErrType.error;
    return _dispatch(_errType, msg, errorOrException);
  }

  /// A warning. Will stay on screen for 3 seconds. Needs a context
  /// to be shown on screen
  Future<Err> warning({String msg, dynamic errorOrException}) async {
    if (msg == null && errorOrException == null)
      throw ArgumentError(
          "You must provide either an errorOrException or a msg to build a warning");
    ErrType _errType = ErrType.warning;
    return _dispatch(_errType, msg, errorOrException, short: true);
  }

  /// A warning. Will stay on screen until dismissed. Needs a context
  /// to be shown on screen
  Future<Err> warningLong({String msg, dynamic errorOrException}) async {
    if (msg == null && errorOrException == null)
      throw ArgumentError(
          "You must provide either an errorOrException or a msg to build a warning");
    ErrType _errType = ErrType.warning;
    return _dispatch(_errType, msg, errorOrException);
  }

  /// An info message. Will stay on screen for 3 seconds. Needs a context
  /// to be shown on screen
  Future<Err> info({String msg, dynamic errorOrException}) async {
    if (msg == null && errorOrException == null)
      throw ArgumentError(
          "You must provide either an errorOrException or a msg to build an info msg");
    ErrType _errType = ErrType.info;
    return _dispatch(_errType, msg, errorOrException, short: true);
  }

  /// A flash info message. Will stay on screen for 1 second. Does not need
  /// a context to be shown
  Future<Err> infoFlash({String msg, dynamic errorOrException}) async {
    if (msg == null && errorOrException == null)
      throw ArgumentError(
          "You must provide either an errorOrException or a msg to build an info msg");
    ErrType _errType = ErrType.info;
    return _dispatch(_errType, msg, errorOrException, flash: true);
  }

  /// A debug message. Will stay on screen for 3 seconds. Needs a context
  /// to be shown on screen
  Future<Err> debug({String msg, dynamic errorOrException}) async {
    if (msg == null && errorOrException == null)
      throw ArgumentError(
          "You must provide either an errorOrException or a msg to build a debug msg");
    ErrType _errType = ErrType.debug;
    return _dispatch(_errType, msg, errorOrException, short: true);
  }

  /// A debug message. Will stay on screen until dismissed. Needs a context
  /// to be shown on screen
  Future<Err> debugLong({String msg, dynamic errorOrException}) async {
    if (msg == null && errorOrException == null)
      throw ArgumentError(
          "You must provide either an errorOrException or a msg to build a debug msg");
    ErrType _errType = ErrType.debug;
    return _dispatch(_errType, msg, errorOrException);
  }

  /// A flash info message. Will stay on screen for 1 second. Does not need
  /// a context to be shown
  Future<Err> debugFlash({String msg, dynamic errorOrException}) async {
    if (msg == null && errorOrException == null)
      throw ArgumentError(
          "You must provide either an errorOrException or a msg to build a debug msg");
    ErrType _errType = ErrType.debug;
    return _dispatch(_errType, msg, errorOrException, flash: true);
  }

  Err _dispatch(ErrType _errType, String _message, dynamic _errorOrException,
      {bool short = false, bool flash = false}) {
    String _errMsg = _getErrMessage(
      _message,
      _errorOrException,
    );
    if (_errorRoutes[_errType].contains(ErrRoute.blackHole)) {
      return Err();
    }
    if (_errorRoutes[_errType].contains(ErrRoute.console)) {
      _printErr(_errType, _errMsg);
    }
    if (_errorRoutes[_errType].contains(ErrRoute.screen)) {
      switch (flash) {
        case true:
          var colors = _getColors(_errType);
          return Err(
              toast: ShortToast(
                  errMsg: _errMsg,
                  backgroundColor: colors["background_color"],
                  textColor: colors["text_color"]));
      }
      return Err(flushbar: _buildFlushbar(_errType, _errMsg, short: short));
    }
    return Err();
  }

  _printErr(ErrType _errType, String _errMsg) {
    switch (_errType) {
      case ErrType.critical:
        bool hasBar = (_errMsg.length > 65 || _errMsg.contains("\n"));
        String endStr;
        hasBar ? endStr = "\n➖➖➖➖➖➖➖➖" : endStr = "";
        String icon;
        terminalColors ? icon = "✖️ " : icon = "✖️✖️✖️";
        print("$icon CRITICAL: $_errMsg$endStr");
        break;
      case ErrType.error:
        bool hasBar = (_errMsg.length > 65 || _errMsg.contains("\n"));
        String endStr;
        String icon;
        terminalColors ? icon = "🔴" : icon = "⏺⏺⏺";
        hasBar ? endStr = "\n➖➖➖➖➖➖➖➖" : endStr = "";
        print("$icon ERROR: $_errMsg$endStr");
        break;
      case ErrType.warning:
        String icon;
        terminalColors ? icon = "⚠️ " : icon = "⏹ ⚠️";
        print("$icon WARNING: $_errMsg");
        break;
      case ErrType.info:
        String icon;
        terminalColors ? icon = "🔔" : icon = "▶️";
        print("$icon INFO: $_errMsg");
        break;
      case ErrType.debug:
        print("📞 DEBUG: $_errMsg");
        break;
      default:
        print("$_errMsg");
    }
  }

  Flushbar _buildFlushbar(ErrType _errType, String _errMsg,
      {bool short = false}) {
    var colors = _getColors(_errType);
    IconData _icon;
    Color _backgroundColor = colors["background_color"];
    Color _iconColor = Colors.white;
    Color _leftBarIndicatorColor;
    Color _textColor = colors["text_color"];
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
      duration: short ? Duration(seconds: 3) : null,
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
    Color _backgroundColor = Colors.black;
    Color _textColor = Colors.white;
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
    }
    return {
      "background_color": _backgroundColor,
      "text_color": _textColor,
    };
  }

  String _getErrMessage(String _message, dynamic _errorOrException) {
    String _endMsg = "";
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
      default:
        type = "Unknown";
    }
    return type;
  }
}

/// The err return object used by [show] : either a [Flushbar], a
/// [Toast] or nothing
class Err {
  Err({this.flushbar, this.toast});

  final Flushbar flushbar;
  final ShortToast toast;

  /// The show method to pop the message on screen if needed.
  /// A [BuildContext] is required only for [Flushbar] messages,
  /// not the flash messages that use [Toast]
  show([BuildContext context]) {
    if (toast != null) {
      toast.show();
      return;
    }
    if (flushbar != null) {
      if (context == null)
        throw ArgumentError(
            "Pass the context to show if you use anything other than flash messages");
      flushbar.show(context);
      return;
    }
  }
}

class ShortToast {
  ShortToast(
      {@required this.backgroundColor,
      @required this.textColor,
      @required this.errMsg});

  final Color backgroundColor;
  final Color textColor;
  final String errMsg;

  show([BuildContext _]) {
    Fluttertoast.showToast(
        msg: errMsg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: 16.0);
  }
}
