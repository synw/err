import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// The route destinations
enum ErrRoute {
  /// The terminal route
  console,

  /// Route for screen and flash messages
  screen,

  /// Route to nowhere: silently swallow the messages
  blackHole
}

/// The error channels
enum ErrType {
  /// Critical errors
  critical,

  /// Normal errors
  error,

  /// Warning level
  warning,

  /// Info level
  info,

  /// Debug level
  debug
}

/// The error router
class ErrRouter {
  /// The main constructor: provides default routes to console. Set your
  /// routes using the parameters
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

  /// Destinations for the critical errors
  List<ErrRoute> criticalRoute;

  /// Destinations for the errors
  List<ErrRoute> errorRoute;

  /// Destinations for the warnings
  List<ErrRoute> warningRoute;

  /// Destination for the info messages
  List<ErrRoute> infoRoute;

  /// Destination for the debug messages
  List<ErrRoute> debugRoute;

  /// Use a terminal tha support colored emojis
  bool terminalColors;

  Map<ErrType, List<ErrRoute>> _errorRoutes;

  /// A critical error
  Future<void> critical(String msg, {dynamic err}) async {
    /// An error or exception can be passed to [err]
    if (msg == null) throw (ArgumentError.notNull());
    _dispatch(ErrType.critical, msg: msg, errorOrException: err);
  }

  /// A critical error
  ///
  /// Will stay on screen until dismissed.
  Future<void> criticalScreen(String msg,
      {@required BuildContext context, dynamic err}) async {
    /// An error or exception can be passed to [err]
    if (msg == null) throw (ArgumentError.notNull());
    _dispatch(ErrType.critical,
        msg: msg, errorOrException: err, toScreen: true, context: context);
  }

  /// An error message
  Future<void> error(String msg, {dynamic err}) async {
    /// An error or exception can be passed to [err]
    if (msg == null) throw (ArgumentError.notNull());
    _dispatch(ErrType.error, msg: msg, errorOrException: err);
  }

  /// An error message
  ///
  /// Will stay on screen until dismissed.
  Future<void> errorScreen(String msg,
      {@required BuildContext context, dynamic err}) async {
    /// An error or exception can be passed to [err]
    if (msg == null) throw (ArgumentError.notNull());
    _dispatch(ErrType.error,
        msg: msg, errorOrException: err, context: context, toScreen: true);
  }

  /// A warning from a message.
  Future<void> warning(String msg, {dynamic err}) async {
    /// An error or exception can be passed to [err]
    if (msg == null) throw (ArgumentError.notNull());
    _dispatch(ErrType.warning, msg: msg, errorOrException: err);
  }

  /// A warning from a message.
  ///
  /// Will stay on the screen until dismissed
  Future<void> warningScreen(String msg,
      {@required BuildContext context, dynamic err, bool short = true}) async {
    /// A [context] has to be provided for the message to print on device screen
    /// If [short] is true it will stay on screen only for 3 seconds, if false
    /// it will stay until dismissed. An error or exception can be passed
    /// to [err]
    if (msg == null) throw (ArgumentError.notNull());
    _dispatch(ErrType.warning,
        msg: msg,
        errorOrException: err,
        short: short,
        toScreen: true,
        context: context);
  }

  /// A warning flash message.
  ///
  /// Will stay on screen for 1 second
  Future<void> warningFlash(String msg) async {
    if (msg == null) throw (ArgumentError.notNull());
    _dispatch(ErrType.warning, msg: msg, toScreen: true, flash: true);
  }

  /// An info message.
  Future<void> info(String msg) async {
    if (msg == null) throw (ArgumentError.notNull());
    _dispatch(ErrType.info, msg: msg);
  }

  /// An info message.
  Future<void> infoScreen(String msg,
      {@required BuildContext context, bool short = true}) async {
    /// A [context] has to be provided for the message to print on device screen
    /// If [short] is true it will stay on screen only for 3 seconds, if false
    /// it will stay until dismissed
    if (msg == null) throw (ArgumentError.notNull());
    if (context == null) throw (ArgumentError.notNull());
    _dispatch(ErrType.info,
        msg: msg, short: true, toScreen: true, context: context);
  }

  /// An info flash message.
  ///
  /// Will stay on the screen for 1 second
  Future<void> infoFlash(String msg) async {
    if (msg == null) throw (ArgumentError.notNull());
    _dispatch(ErrType.info, msg: msg, toScreen: true, flash: true);
  }

  /// An debug message
  Future<void> debug(String msg, {dynamic err}) async {
    /// An error or exception can be passed to [err]
    if (msg == null) throw (ArgumentError.notNull());
    _dispatch(ErrType.debug, msg: msg, errorOrException: err);
  }

  /// An debug message sent to the screen
  Future<void> debugScreen(String msg,
      {@required BuildContext context, dynamic err, bool short = false}) async {
    /// An error or exception can be passed to [err]. Will stay until dismissed
    /// or if [short] is true it will stay for 3 seconds on screen
    if (msg == null) throw (ArgumentError.notNull());
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
    if (msg == null) throw (ArgumentError.notNull());
    _dispatch(ErrType.debug, toScreen: true, msg: msg, flash: true);
  }

  /// An alias for infoFlash
  Future<void> flash(String msg) async {
    infoFlash(msg);
  }

  void _dispatch(ErrType _errType,
      {BuildContext context,
      String msg,
      dynamic errorOrException,
      bool short = false,
      bool flash = false,
      bool toScreen = false}) {
    String _errMsg = _getErrMessage(
      msg,
      errorOrException,
    );
    if (_errorRoutes[_errType].contains(ErrRoute.blackHole)) {
      return null;
    }
    if (_errorRoutes[_errType].contains(ErrRoute.console)) {
      _printErr(_errType, _errMsg);
    }
    if (_errorRoutes[_errType].contains(ErrRoute.screen) && toScreen == true) {
      _Err err = _buildScreenMessage(_errType, _errMsg, errorOrException,
          short: short, flash: flash);
      _popMsg(err: err, context: context);
    }
  }

  _Err _buildScreenMessage(
      ErrType _errType, String _errMsg, dynamic _errorOrException,
      {bool short = false, bool flash = false}) {
    switch (flash) {
      case true:
        var colors = _getColors(_errType);
        return _Err(
            msg: _errMsg,
            type: _errType,
            toast: _ShortToast(
                errMsg: _errMsg,
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

  void _printErr(ErrType _errType, String _errMsg) {
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
      duration: short ? Duration(seconds: 5) : Duration(days: 365),
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
        break;
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
      if (context == null)
        throw ArgumentError(
            "Pass the context to show if you use anything other " +
                "than flash messages");
      flushbar.show(context);
      return;
    }
  }
}

class _ShortToast {
  _ShortToast(
      {@required this.backgroundColor,
      @required this.textColor,
      @required this.errMsg});

  final Color backgroundColor;
  final Color textColor;
  final String errMsg;

  void show([BuildContext _]) {
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
