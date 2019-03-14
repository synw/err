import 'package:flutter/material.dart';
import 'logger.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Err example',
      home: MyHomePage(),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    logger.debugFlash("Init state");
    super.initState();
  }

  bool _firstBuildDone = false;

  @override
  Widget build(BuildContext context) {
    if (!_firstBuildDone)
      logger.debugFlash("First build").then((_) {
        _firstBuildDone = true;
      });
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(25.0),
            child: ListView(
              children: <Widget>[
                RaisedButton(
                  child: const Text("Info flash message"),
                  onPressed: () => logger.infoFlash("An info flash message"),
                ),
                RaisedButton(
                    child: const Text("Info regular message"),
                    onPressed: () =>
                        logger.infoScreen("An info message", context: context)),
                RaisedButton(
                    child: const Text("Warning message"),
                    onPressed: () => logger.warningScreen(
                        "Hey, this is warning!",
                        context: context)),
                RaisedButton(
                    child: const Text("Error message"),
                    onPressed: () => logger.errorScreen("Something went wrong",
                        context: context)),
                RaisedButton(
                    child: const Text("Critical message from exception"),
                    onPressed: () {
                      try {
                        _doWrong();
                      } catch (e) {
                        logger.criticalScreen("Something went really wrong",
                            err: e, context: context);
                      }
                    }),
                RaisedButton(
                    child: const Text("Debug message"),
                    onPressed: () => logger.debugScreen("Debug info message",
                        context: context)),
              ],
            )));
  }

  void _doWrong() {
    List<String> li;
    li.add("wrong");
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
