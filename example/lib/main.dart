import 'package:flutter/material.dart';
import 'package:err/err.dart';
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

  bool firstBuildDone = false;

  @override
  Widget build(BuildContext context) {
    if (!firstBuildDone)
      logger.debugFlash("First build").then((_) {
        firstBuildDone = true;
      });
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.all(25.0),
            child: ListView(
              children: <Widget>[
                RaisedButton(
                  child: Text("Info flash message"),
                  onPressed: () => logger.infoFlash("An info flash message"),
                ),
                RaisedButton(
                  child: Text("Notification message"),
                  onPressed: () => logger.notify(
                      msg: "An error has occurred", errType: ErrType.error),
                ),
                RaisedButton(
                    child: Text("Info regular message"),
                    onPressed: () => logger.info("An info message", context)),
                RaisedButton(
                    child: Text("Warning message"),
                    onPressed: () =>
                        logger.warning("Hey, this is warning!", context)),
                RaisedButton(
                    child: Text("Error message"),
                    onPressed: () =>
                        logger.error("Something went wrong", context)),
                RaisedButton(
                    child: Text("Critical message from exception"),
                    onPressed: () {
                      try {
                        _doWrong();
                      } catch (e) {
                        logger.criticalErrSync(
                            msg: "Something went really wrong",
                            err: e,
                            context: context);
                      }
                    }),
                RaisedButton(
                    child: Text("Debug message"),
                    onPressed: () =>
                        logger.debug("Debug info message", context)),
              ],
            )));
  }

  _doWrong() {
    List<String> li;
    li.add("wrong");
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
