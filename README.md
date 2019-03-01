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
      logger.debugFlash("Init state");
       super.initState();
   }
   ```

Available flash messages:

**`debugFlash`**(`String` *msg*): a debug message

**`infoFlash`**(`String` *msg*): an information message

![Screenshot](img/info_flash.png)

### Regular messages

The regular messages are snackbar messages. They need a `BuildContext`

   ```dart
   logger.info("File uploaded in $elapsed s", context: context);
   logger.debug("A debug message", context: context);
   try {
      somethingWrong();
   } catch(ex) {
      logger.criticalErrSync(
         err: ex,
         msg: "Something wrong happened",
         context: context);  
   }
   ```

Available messages:

**`critical`**(`String` *msg*): will stay on screen until dismissed

**`criticalErr`**({`String` *msg*, `dynamic` *err*}): `err` is an error or an exception. Will stay on screen until dismissed

**`error`**(`String` *msg*): will stay on screen until dismissed

**`errorErr`**({`String` *msg*, `dynamic` *err*}): `err` is an error or an exception. Will stay on screen until dismissed

**`warning`**(`String` *msg*): will stay on screen until dismissed

**`warningErr`**({`String` *msg*, `dynamic` *err*}): `err` is an error or an exception. Will stay on screen until dismissed

**`warningShort`**(`String` *msg*): will stay on screen for 3 seconds

**`warningErrShort`**({`String` *msg*, `dynamic` *err*}): `err` is an error or an exception. Will stay on screen for 3 seconds

**`info`**(`String` *msg*): will stay on screen for 3 seconds

**`debug`**(`String` *msg*): will stay on screen for 3 seconds

All the functions are async. To use them in a synchronous maner append
`Sync` to their name. Ex: `errorSync()`.

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
