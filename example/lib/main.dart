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
    log.console("Init state");
    super.initState();
  }

  bool _firstBuildDone = false;

  @override
  Widget build(BuildContext context) {
    if (!_firstBuildDone) {
      log.flash("First build");
    }
    _firstBuildDone = true;

    return Scaffold(
        appBar: AppBar(
          title: const Text("Err"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.insert_drive_file),
                onPressed: () => Navigator.of(context).push<DeviceConsolePage>(
                        MaterialPageRoute<DeviceConsolePage>(
                            builder: (BuildContext context) {
                      return DeviceConsolePage(log);
                    })))
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(25.0),
            child: ListView(
              children: <Widget>[
                RaisedButton(
                  child: const Text("Info flash message"),
                  onPressed: () => log.flash("An info flash message"),
                ),
                RaisedButton(
                    child: const Text("Warning message"),
                    onPressed: () => log.screen(
                        Err.warning("Hey, this is warning!"), context)),
                RaisedButton(
                    child: const Text("Error message"),
                    onPressed: () =>
                        log.screen(Err.error("Something went wrong"), context)),
                RaisedButton(
                    child: const Text("Critical message from exception"),
                    onPressed: () {
                      try {
                        _doWrong();
                      } catch (e) {
                        log.screen(Err.critical("Something went really wrong"),
                            context);
                      }
                    }),
                RaisedButton(
                    child: const Text("Debug message"),
                    onPressed: () =>
                        log.screen(Err.debug("Debug info message"), context)),
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
