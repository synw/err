# Err

A logs router that can pop messages to the device's screen.

## Configuration

Configure the log levels routes: available routes: console, screen or black hole. All the logs routed to the black hole will be silently swallowed
without mercy. All routes default to console.

   ```dart
   import 'package:err/err.dart';

   var logger = ErrRouter(
      criticalRoute: [ErrRoute.console],
      errorRoute: [ErrRoute.screen, ErrRoute.console],
      warningRoute: [ErrRoute.screen, ErrRoute.console],
      infoRoute: [ErrRoute.screen],
      debugRoute: [ErrRoute.blackHole]);
   ```

## Screen route usage

### Flash messages

The flash messages are toast messages:

   ```dart
   @override
   void initState() {
      logger.debugFlash(msg: "Init state").then((err) {
         err.show();
       });
       super.initState();
   }
   ```

Available flash messages:

**`debugFlash`**(`String` *msg*, `Exception or Error` *errorOrException*)

**`infoFlash`**(`String` *msg*, `Exception or Error` *errorOrException*)

### Regular messages

The regular messages are snackbar messages. They need a `BuildContext`:

   ```dart
   logger.info(msg: "File uploaded in $elapsed s").then((msg) {
      msg.show(context);
   });
   ```

Available messages:

**`critical`**(`String` *msg*, `Exception or Error` *errorOrException*): will
stay until dismissed

**`error`**(`String` *msg*, `Exception or Error` *errorOrException*): will
stay until dismissed

**`warning`**(`String` *msg*, `Exception or Error` *errorOrException*): will
stay for 3 seconds

**`warningLong`**(`String` *msg*, `Exception or Error` *errorOrException*): will
stay until dismissed

**`info`**(`String` *msg*, `Exception or Error` *errorOrException*): will
stay for 3 seconds

**`debug`**(`String` *msg*, `Exception or Error` *errorOrException*): will
stay for 3 seconds

**`debugLong`**(`String` *msg*, `Exception or Error` *errorOrException*): will
stay until dismissed

## Libraries used

- [Flutter toast](https://pub.dartlang.org/packages/fluttertoast)
- [Flushbar](https://pub.dartlang.org/packages/flushbar)
