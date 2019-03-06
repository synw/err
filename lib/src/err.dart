import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// The route destinations
enum ErrRoute { console, screen, blackHole }

/// The error channels
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

  /// A critical error from a message. Will stay on screen until dismissed.
  void criticalSync(String msg, [BuildContext context]) {
    /// A [context] is required if the message goes to screen
    if (msg == null) throw (ArgumentError.notNull());
    _dispatch(ErrType.critical, msg: msg, context: context);
  }

  /// A critical error from a message. Will stay on screen until dismissed.
  Future<void> critical(String msg, [BuildContext context]) async {
    /// A [context] is required if the message goes to screen
    if (msg == null) throw (ArgumentError.notNull());
    _dispatch(ErrType.critical, msg: msg, context: context);
  }

  /// A critical error from an error or exception.
  /// Will stay on screen until dismissed.
  void criticalErrSync({String msg, dynamic err, BuildContext context}) {
    /// A [context] is required if the message goes to screen
    if (err == null && msg == null) throw (ArgumentError.notNull());
    _dispatch(ErrType.critical, errorOrException: err, context: context);
  }

  /// A critical error from an error or exception.
  /// Will stay on screen until dismissed.
  Future<void> criticalErr(
      {String msg, dynamic err, BuildContext context}) async {
    /// A [context] is required if the message goes to screen
    if (err == null && msg == null) throw (ArgumentError.notNull());
    _dispatch(ErrType.critical, errorOrException: err, context: context);
  }

  /// An error from a message. Will stay on screen until dismissed.
  void errorSync(String msg, [BuildContext context]) {
    /// A [context] is required if the message goes to screen
    if (msg == null) throw (ArgumentError.notNull());
    _dispatch(ErrType.error, msg: msg, context: context);
  }

  /// An error from a message. Will stay on screen until dismissed.
  Future<void> error(String msg, [BuildContext context]) async {
    /// A [context] is required if the message goes to screen
    if (msg == null) throw (ArgumentError.notNull());
    _dispatch(ErrType.error, msg: msg, context: context);
  }

  /// An error from an error or exception.
  /// Will stay on screen until dismissed.
  void errorErrSync({String msg, dynamic err, BuildContext context}) {
    /// A [context] is required if the message goes to screen
    if (err == null && msg == null) throw (ArgumentError.notNull());
    _dispatch(ErrType.error, errorOrException: err, context: context);
  }

  /// An error from an error or exception.
  /// Will stay on screen until dismissed.
  Future<void> errorErr({String msg, dynamic err, BuildContext context}) async {
    /// A [context] is required if the message goes to screen
    if (err == null && msg == null) throw (ArgumentError.notNull());
    _dispatch(ErrType.error, errorOrException: err, context: context);
  }

  /// A warning from a message. Will stay on the screen until dismissed
  void warningSync(String msg, [BuildContext context]) {
    /// A [context] is required if the message goes to screen
    if (msg == null) throw (ArgumentError.notNull());
    _dispatch(ErrType.warning, msg: msg, context: context);
  }

  /// A warning from a message. Will stay on the screen until dismissed
  Future<void> warning(String msg, [BuildContext context]) async {
    /// A [context] is required if the message goes to screen
    if (msg == null) throw (ArgumentError.notNull());
    _dispatch(ErrType.warning, msg: msg, context: context);
  }

  /// A warning from an error or exception.
  /// Will stay on the screen until dismissed
  void warningErrSync({String msg, dynamic err, BuildContext context}) {
    /// A [context] is required if the message goes to screen
    if (err == null && msg == null) throw (ArgumentError.notNull());
    _dispatch(ErrType.warning, errorOrException: err, context: context);
  }

  /// A warning from an error or exception.
  /// Will stay on the screen until dismissed
  Future<void> warningErr(
      {String msg, dynamic err, BuildContext context}) async {
    /// A [context] is required if the message goes to screen
    if (err == null && msg == null) throw (ArgumentError.notNull());
    _dispatch(ErrType.warning, errorOrException: err, context: context);
  }

  /// A warning from a message. Will stay on the screen for 3 seconds
  void warningShortSync(String msg, [BuildContext context]) {
    /// A [context] is required if the message goes to screen
    if (msg == null) throw (ArgumentError.notNull());
    _dispatch(ErrType.warning, msg: msg, short: true, context: context);
  }

  /// A warning from a message. Will stay on the screen for 3 seconds
  Future<void> warningShort(String msg, [BuildContext context]) async {
    /// A [context] is required if the message goes to screen
    if (msg == null) throw (ArgumentError.notNull());
    _dispatch(ErrType.warning, msg: msg, short: true, context: context);
  }

  /// A warning from an error or exception.
  /// Will stay on the screen for 3 seconds
  void warningErrShortSync({String msg, dynamic err, BuildContext context}) {
    /// A [context] is required if the message goes to screen
    if (err == null) throw (ArgumentError.notNull());
    _dispatch(ErrType.warning,
        errorOrException: err, short: true, context: context);
  }

  /// A warning from an error or exception.
  /// Will stay on the screen for 3 seconds
  Future<void> warningErrShort(
      {String msg, dynamic err, BuildContext context}) async {
    /// A [context] is required if the message goes to screen
    if (err == null) throw (ArgumentError.notNull());
    _dispatch(ErrType.warning,
        errorOrException: err, short: true, context: context);
  }

  /// An info from a message. Will stay on the screen for 3 seconds
  void infoSync(String msg, [BuildContext context]) {
    /// A [context] is required if the message goes to screen
    if (msg == null) throw (ArgumentError.notNull());
    _dispatch(ErrType.info, msg: msg, short: true, context: context);
  }

  /// An info from a message. Will stay on the screen for 3 seconds
  Future<void> info(String msg, [BuildContext context]) async {
    /// A [context] is required if the message goes to screen
    if (msg == null) throw (ArgumentError.notNull());
    _dispatch(ErrType.info, msg: msg, short: true, context: context);
  }

  /// An info flash from a message. Will stay on the screen for 1 second
  void infoFlashSync(String msg) {
    if (msg == null) throw (ArgumentError.notNull());
    _dispatch(ErrType.info, msg: msg, flash: true);
  }

  /// An info flash from a message. Will stay on the screen for 1 second
  Future<void> infoFlash(String msg) async {
    if (msg == null) throw (ArgumentError.notNull());
    _dispatch(ErrType.info, msg: msg, flash: true);
  }

  /// An debug message from a message. Will stay on the screen for 3 seconds
  void debugSync(String msg, [BuildContext context]) {
    /// A [context] is required if the message goes to screen
    if (msg == null) throw (ArgumentError.notNull());
    _dispatch(ErrType.debug, msg: msg, short: true, context: context);
  }

  /// An debug message from a message. Will stay on the screen for 3 seconds
  Future<void> debug(String msg, [BuildContext context]) async {
    /// A [context] is required if the message goes to screen
    if (msg == null) throw (ArgumentError.notNull());
    _dispatch(ErrType.debug, msg: msg, short: true, context: context);
  }

  /// An debug flash message from a message.
  /// Will stay on the screen for 1 second
  void debugFlashSync(String msg) {
    if (msg == null) throw (ArgumentError.notNull());
    _dispatch(ErrType.debug, msg: msg, flash: true);
  }

  /// An debug flash message from a message.
  /// Will stay on the screen for 1 second
  Future<void> debugFlash(String msg) async {
    if (msg == null) throw (ArgumentError.notNull());
    _dispatch(ErrType.debug, msg: msg, flash: true);
  }

  /// An alias for debugFlash
  Future<void> flash(String msg) async {
    if (msg == null) throw (ArgumentError.notNull());
    _dispatch(ErrType.debug, msg: msg, flash: true);
  }

  void _dispatch(ErrType _errType,
      {BuildContext context,
      String msg,
      dynamic errorOrException,
      bool short = false,
      bool flash = false}) {
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
    if (_errorRoutes[_errType].contains(ErrRoute.screen)) {
      if (flash == false && context == null)
        throw ArgumentError(
            "You must provide a context if your message goes to the screen and is not flash");
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
            toast: ShortToast(
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
  final ShortToast toast;
  final String msg;
  final ErrType type;

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
