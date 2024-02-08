import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class ServiceTestScreen extends StatefulWidget {
  const ServiceTestScreen({super.key, required this.title});
  final String title;
  @override
  State<ServiceTestScreen> createState() => _ServiceTestScreenState();
}

class _ServiceTestScreenState extends State<ServiceTestScreen> {
  String servicestate = "Stop Service";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  FlutterBackgroundService().invoke("setAsForeground");
                },
                child: const Text('Set as Foreground')),
            const SizedBox(height: 10.0),
            ElevatedButton(
                onPressed: () {
                  FlutterBackgroundService().invoke("setAsBackground");
                },
                child: const Text('Set as Background')),
            const SizedBox(height: 10.0),
            ElevatedButton(
                onPressed: () async {
                  final service = FlutterBackgroundService();
                  var isRunning = await service.isRunning();
                  if (isRunning) {
                    service.invoke("stopService");
                    servicestate = "Stop Service";
                  } else {
                    service.startService();
                    servicestate = "Start Service";
                  }
                  setState(() {
                    servicestate = (servicestate == "Start Service")
                        ? "Stop Service"
                        : "Start Service";
                  });
                },
                child: Text(servicestate)),
          ],
        ),
      ),
    );
  }
}
