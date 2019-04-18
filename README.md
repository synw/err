# Err

[![pub package](https://img.shields.io/pub/v/err.svg)](https://pub.dartlang.org/packages/err) [![api doc](img/api-doc.svg)](https://pub.dartlang.org/documentation/err/latest/err/err-library.html)

A logs router. The messages can be routed to:

- Terminal
- Flash messages
- Snackbar messages

## Configuration

Configure the log levels's routes: available routes: console, screen, notifications or black hole. All the logs routed to the black hole will be silently swallowed: use it this to disable a route. 

All routes default to console.

   ```dart
   import 'package:err/err.dart';

   var logger = ErrRouter(
      criticalRoute: [ErrRoute.console, ErrRoute.screen],
      errorRoute: [ErrRoute.screen, ErrRoute.console],
      warningRoute: [ErrRoute.screen, ErrRoute.console],
      infoRoute: [ErrRoute.screen],
      debugRoute: [ErrRoute.blackHole]);
   ```

## Screen route

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

**`infoFlash`**(`String` *msg*): an information message

**`debugFlash`**(`String` *msg*): a debug message

**`warningFlash`**(`String` *msg*): a warning message

**`flash`**(`String` *msg*): alias for `debugFlash`

![Screenshot](img/info_flash.png)

### Snackbar messages

The snackbar messages need a `BuildContext`

   ```dart
   logger.infoScreen("File uploaded in $elapsed s", context: context);
   logger.debugScreen("A debug message", context: context);
   try {
      somethingWrong();
   } catch(ex) {
      logger.criticalScreen(
         err: ex,
         msg: "Something wrong happened",
         context: context);  
   }
   ```

#### Available messages

**`criticalScreen`**(`String` *msg*, {`@required BuildContext` *context*, `dynamic` *err*})

**`errorScreen`**(`String` *msg*, {`@required BuildContext` *context*, `dynamic` *err*})

**`warningScreen`**(`String` *msg*, {`@required BuildContext` *context*,`dynamic` *err*, `bool` *short*})

**`infoScreen`**(`String` *msg*, {`@required BuildContext` *context*,`dynamic` *err*, `bool` *short*})

**`debugScreen`**(`String` *msg*, {`@required BuildContext` *context*,`dynamic` *err*, `bool` *short*})

#### Parameters:

**msg** : a text message

**err** : an error or exception

**short** : if enabled the message will stay on screen for 5 seconds. If not it will stay until dismissed

**context** : the build context required for screen messages

![Screenshot](img/messages.png)

## Console route

**`critical`**(`String` *msg*, {`dynamic` *err*})

**`error`**(`String` *msg*)

**`warning`**(`String` *msg*, {`dynamic` *err*})

**`info`**(`String` *msg*)

**`debug`**(`String` *msg*, {`dynamic` *err*})

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
