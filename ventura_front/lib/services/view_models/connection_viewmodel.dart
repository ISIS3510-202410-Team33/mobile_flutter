import '../../mvvm_components/viewmodel.dart';
import '../../mvvm_components/observer.dart';
import 'dart:async';
import 'dart:isolate';
import 'dart:io';


class ConnectionViewModel extends EventViewModel{

  static final ConnectionViewModel _instance = ConnectionViewModel._internal();


  late bool _isConnected;
  late ReceivePort _receivePort;
  late Isolate _isolate;
  bool _started = false;
  bool firstTime = true;

  factory ConnectionViewModel() {
    return _instance;
  }

  ConnectionViewModel._internal() {
    print("New ConnectionViewModel");
    if (_started == false) {
      print("Starting ConnectionViewModel");
      _receivePort = ReceivePort();
      _startInternetCheckIsolate();
    }
  }

  void _startInternetCheckIsolate() async {
    print("Creating isolate...");
    _isolate = await  Isolate.spawn(_checkInternetIsolate, _receivePort.sendPort);
    print("Isolate Created ");
    // Escuchar el puerto para recibir mensajes del Isolate.
    _receivePort.listen((dynamic data) {
      
      if (_started) {
        if (_isConnected != data){
          spreadConnectionState(data);
        }
      }
      if (firstTime) {
        spreadConnectionState(data);
        firstTime = false;
      }
      _isConnected = data;
      _started = true;
    });
  }

  // Método que se ejecutará en el Isolate.
  static void _checkInternetIsolate(SendPort sendPort) {
    int counter = 0;
    Timer.periodic( Duration(seconds: counter), (timer) async {
      bool isConnected = await _checkInternetConnection();
      counter = 1;
      sendPort.send(isConnected);
    });
  }

  // Método para verificar la conexión a Internet.
  static Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup("ventura-backend-jaj1.onrender.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    }  catch (_) {
      return false;
    }
  }

  bool isConnected() {
    return _isConnected;
  }

  void disposeConnection() {
    _receivePort.close();
    _isolate.kill();
  }

  void spreadConnectionState(bool state){
    notify(ConnectionEvent(connection: state));
  }
  

}

class ConnectionEvent extends ViewEvent {
  bool connection;
  ConnectionEvent({required this.connection}) : super("ConnectionEvent");
}
