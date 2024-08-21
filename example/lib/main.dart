import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:scrumlab_flutter_appavailability/scrumlab_flutter_appavailability.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Map<String, String>>? installedApps;
  final List<Map<String, String>> iOSApps = [
    {"app_name": "Calendar", "package_name": "calshow://"},
    {"app_name": "Facebook", "package_name": "fb://"},
    {"app_name": "Whatsapp", "package_name": "whatsapp://"}
  ];

  @override
  void initState() {
    super.initState();
    getApps();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> getApps() async {
    List<Map<String, String>> _installedApps = [];

    if (Platform.isAndroid) {
      _installedApps = await ScrumlabAppAvailability.getInstalledApps();

      print(await ScrumlabAppAvailability.checkAvailability(
          "com.android.chrome"));
      // Returns: Map<String, String>{app_name: Chrome, package_name: com.android.chrome, versionCode: null, version_name: 55.0.2883.91}

      print(await ScrumlabAppAvailability.isAppEnabled("com.android.chrome"));
      // Returns: true
    } else if (Platform.isIOS) {
      // iOS doesn't allow to get installed apps.
      _installedApps = iOSApps;

      print(await ScrumlabAppAvailability.checkAvailability("calshow://"));
      // Returns: Map<String, String>{app_name: , package_name: calshow://, versionCode: , version_name: }
    }

    setState(() {
      installedApps = _installedApps;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin scrumlab_flutter_appavailability app'),
        ),
        body: ListView.builder(
          itemCount: installedApps?.length ?? 0,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(installedApps![index]["app_name"] ?? ''),
              trailing: IconButton(
                icon: const Icon(Icons.open_in_new),
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScrumlabAppAvailability.launchApp(
                          installedApps![index]["package_name"] ?? '')
                      .then((_) {
                    print("App ${installedApps![index]["app_name"]} launched!");
                  }).catchError((err) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "App ${installedApps![index]["app_name"]} not found!")));
                    print(err);
                  });
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
