import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'dart:async';
import 'package:proximity_sensor/proximity_sensor.dart';


class Proximity extends StatefulWidget {
  final Widget child;

  const Proximity({super.key, required this.child}); 
  @override
  _ProximityState createState() => _ProximityState();
}

class _ProximityState extends State<Proximity> {
  bool _isNear = false;
  late StreamSubscription<dynamic> _streamSubscription;

  @override
  void initState() {
    super.initState();
    listenSensor();
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
  }

  Future<void> listenSensor() async {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (foundation.kDebugMode) {
        FlutterError.dumpErrorToConsole(details);
      }
    };
    await ProximitySensor.setProximityScreenOff(true).onError((error, stackTrace) {
      print("could not enable screen off functionality");
      return null;
    });

    _streamSubscription = ProximitySensor.events.listen((int event) {
      setState(() {
        _isNear = (event > 0) ? true : false;
        
      });
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return widget.child;
}
}