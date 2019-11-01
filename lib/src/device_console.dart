import 'package:flutter/material.dart';
import 'err.dart';

/// On device log page
class DeviceConsolePage extends StatelessWidget {
  /// Provide a [logger]
  const DeviceConsolePage(this.logger);

  /// The logger to use
  final ErrRouter logger;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Logs")),
        body: ListView.builder(
          itemCount: logger.messages.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(dense: true, title: Text(logger.messages[index]));
          },
        ));
  }
}
