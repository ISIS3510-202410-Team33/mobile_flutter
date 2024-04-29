import '../../mvvm_components/viewmodel.dart';
import '../../mvvm_components/observer.dart';
import 'dart:async';
import 'dart:isolate';
import 'dart:io';

class ConnectionViewModel extends EventViewModel {
  static final ConnectionViewModel _instance = ConnectionViewModel._internal();

  late bool _isConnected;
  late ReceivePort _receivePort;
  late Isolate _isolate;
  bool _started = false;

  factory ConnectionViewModel() {
    return _instance;
  }

  ConnectionViewModel._internal() {
    _receivePort = ReceivePort();
    _startInternetCheckIsolate();
  }

  void _startInternetCheckIsolate() async {
    print("Creating isolate...");
    _isolate =
        await Isolate.spawn(_checkInternetIsolate, _receivePort.sendPort);
    print("Isolate Created ");
    // Escuchar el puerto para recibir mensajes del Isolate.
    _receivePort.listen((dynamic data) {
      if (_started) {
        if (_isConnected != data) {
          print("Cambio conexion: ${data ? 'Conectado' : 'Desconectado'}");
          spreadConnectionState(data);
        }
      }
      else {
        spreadConnectionState(data);
      }
      _started = true;
      _isConnected = data;
    });
  }

  // Método que se ejecutará en el Isolate.
  static void _checkInternetIsolate(SendPort sendPort) {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      bool isConnected = await _checkInternetConnection();
      sendPort.send(isConnected);
    });
  }

  // Método para verificar la conexión a Internet.
  static Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup("google.com").timeout(const Duration(seconds: 3));
    
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    }  catch (_) {
      return false;
    }
  }

  //Llamar este metodo para verificar si hay conexión a internet, de manera independiente al isolate.
  Future<bool> isInternetConnected() async {
    bool value = await _checkInternetConnection();
    return value;
  }

  bool isConnected() {
    return _isConnected;
  }

  void disposeConnection() {
    _receivePort.close();
    _isolate.kill();
  }

  void spreadConnectionState(bool state) {
    !isSuscribing() ? notify(ConnectionEvent(connection: state)) : null;
  }
}

class ConnectionEvent extends ViewEvent {
  bool connection;
  ConnectionEvent({required this.connection}) : super("ConnectionEvent");
}
