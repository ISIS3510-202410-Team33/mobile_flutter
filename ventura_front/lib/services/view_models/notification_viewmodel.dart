import 'package:flutter/material.dart';
import '../../mvvm_components/observer.dart';
import '../../mvvm_components/viewmodel.dart';
import 'dart:async';
import 'dart:isolate';
import 'dart:io';

class NotificationViewModel extends EventViewModel {
  static final NotificationViewModel _instance = NotificationViewModel._internal();

  late bool _hasNotification;
  late ReceivePort _receivePort;
  late Isolate _isolate;
  bool _started = false;

  factory NotificationViewModel() {
    return _instance;
  }

  NotificationViewModel._internal() {
    print("New NotificationViewModel");
    if (_started == false) {
      print("Starting NotificationViewModel");
      _receivePort = ReceivePort();
      _startNotificationIsolate();
    }
  }

  void _startNotificationIsolate() async {
    print("Creating isolate...");
    _isolate = await Isolate.spawn(_listenForNotificationsIsolate, _receivePort.sendPort);
    print("Isolate Created ");
    // Escuchar el puerto para recibir mensajes del Isolate.
    _receivePort.listen((dynamic data) {
      if (_started) {
        if (_hasNotification != data) {
          spreadNotificationState(data);
        }
      }
      _hasNotification = data;
      _started = true;
    });
  }

  // Método que se ejecutará en el Isolate.
  static void _listenForNotificationsIsolate(SendPort sendPort) {
    Timer.periodic(Duration(seconds: 1), (timer) async {
      bool hasNotification = await _fetchNotificationStatus();
      sendPort.send(hasNotification);
    });
  }

  static Future<bool> _fetchNotificationStatus() async {
    try {
       return true;
    } on SocketException catch (_) {
      return false;
    }
  }

  bool hasNotification() {
    return _hasNotification;
  }

  void disposeNotifications() {
    _receivePort.close();
    _isolate.kill();
  }

  void spreadNotificationState(bool state) {
    notify(NotificationEvent(hasNotification: state));
  }

  @override
  void subscribe(EventObserver o) {
    unsubscribeAll();
    super.subscribe(o);
  }
}

class NotificationEvent extends ViewEvent {
  bool hasNotification;
  NotificationEvent({required this.hasNotification}) : super("NotificationEvent");
}
