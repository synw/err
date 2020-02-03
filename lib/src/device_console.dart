import 'package:flutter/material.dart';

import 'router.dart';

/// On device log page
class DeviceConsolePage extends StatelessWidget {
  /// Provide an [ErrRouter]
  const DeviceConsolePage(this.router);

  /// The logger to use
  final ErrRouter router;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Logs")),
        body: ListView.builder(
          itemCount: router.history.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
                dense: true, title: Text(router.history[index].toString()));
          },
        ));
  }
}
