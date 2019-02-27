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
    logger.debugFlash(msg: "Init state").then((err) {
      err.show();
    });
    super.initState();
  }

  bool firstBuildDone = false;

  @override
  Widget build(BuildContext context) {
    if (!firstBuildDone)
      logger.debugFlash(msg: "First build").then((err) {
        err.show();
        firstBuildDone = true;
      });
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.all(25.0),
            child: ListView(
              children: <Widget>[
                RaisedButton(
                  child: Text("Info flash message"),
                  onPressed: () => logger
                          .infoFlash(msg: "An info flash message")
                          .then((err) {
                        err.show(context);
                      }),
                ),
                RaisedButton(
                  child: Text("Info regular message"),
                  onPressed: () =>
                      logger.info(msg: "An info message").then((err) {
                        err.show(context);
                      }),
                ),
                RaisedButton(
                  child: Text("Warning message"),
                  onPressed: () =>
                      logger.warning(msg: "Hey, this is warning!").then((err) {
                        err.show(context);
                      }),
                ),
                RaisedButton(
                  child: Text("Error message"),
                  onPressed: () =>
                      logger.error(msg: "Something went wrong").then((err) {
                        err.show(context);
                      }),
                ),
                RaisedButton(
                    child: Text("Critical message from exception"),
                    onPressed: () {
                      try {
                        _doWrong();
                      } catch (e) {
                        logger
                            .critical(
                                msg: "Something went really wrong",
                                errorOrException: e)
                            .then((err) {
                          err.show(context);
                        });
                      }
                    }),
                RaisedButton(
                  child: Text("Debug message"),
                  onPressed: () =>
                      logger.debug(msg: "Debug info message").then((err) {
                        err.show(context);
                      }),
                ),
                IconButton(
                  icon: Icon(Icons.refresh, color: Colors.grey, size: 55.0),
                  onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return MyHomePage();
                      })),
                )
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
