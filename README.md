# Err

[![pub package](https://img.shields.io/pub/v/err.svg)](https://pub.dartlang.org/packages/err) [![api doc](img/api-doc.svg)](https://pub.dartlang.org/documentation/err/latest/err/err-library.html)

A logs router that can pop messages to the device screen.

## Configuration

Configure the log levels routes: available routes: console, screen or black hole. All the logs routed to the black hole will be silently swallowed: use
this to disable a route. All routes default to console.

   ```dart
   import 'package:err/err.dart';

   var logger = ErrRouter(
      criticalRoute: [ErrRoute.console, ErrRoute.screen],
      errorRoute: [ErrRoute.screen, ErrRoute.console],
      warningRoute: [ErrRoute.screen, ErrRoute.console],
      infoRoute: [ErrRoute.screen],
      debugRoute: [ErrRoute.blackHole]);
   ```

## Screen route usage

### Flash messages

The flash messages are toast messages. They stay one second on the screen

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

![Screenshot](img/info_flash.png)

### Regular messages

The regular messages are snackbar messages. They need a `BuildContext`

   ```dart
   logger.info(msg: "File uploaded in $elapsed s").then((err) {
      err.show(context);
   });

   // or

   Err err = await logger.info(msg: "File uploaded in $elapsed s");
   // if (err != nil) // hi Go!  Not needed here
   // because the show method will do nothing in case
   // of console route, it's used only to print on screen
   err.show(context);
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

![Screenshot](img/messages.png)

## Console route

![Screenshot](img/terminal.png)

By default the terminal output is configured for black and white. If your terminal supports colorized unicode emoticons use this parameter:

   ```dart
   var logger = ErrRouter(
      // ...
      terminalColors: true);
   ```

![Screenshot](img/terminal_colors.png)

## Libraries used

- [Flutter toast](https://pub.dartlang.org/packages/fluttertoast)
- [Flushbar](https://pub.dartlang.org/packages/flushbar)
