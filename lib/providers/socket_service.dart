import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart';

enum ServerStatus{
  online,
  offline,
  connecting
}

class SocketService with ChangeNotifier{

  ServerStatus _serverStatus = ServerStatus.connecting;
  late Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  Socket get socket => _socket;
  
  SocketService(){
    _initConfig();
  }

  void _initConfig(){
    _socket = io('http://192.168.1.82:3000',
    OptionBuilder()
      .setTransports(['websocket']) // for Flutter or Dart VM
      .enableAutoConnect()  // disable auto-connection
      .build());

    _socket.onConnect((_) {
    _serverStatus = ServerStatus.online;
    notifyListeners();
  });

  _socket.onDisconnect((_) {
    _serverStatus = ServerStatus.offline;
    notifyListeners();
  });

  /* socket.on('nuevo-mensaje', (payload) {
    print('nuevo mensaje');
    print('nombre:' + payload['nombre']);
    print('mensaje:' + payload['mensaje']);
    print(payload.containsKey('mensaje2')? payload['mensaje2']: 'no hay');
  }); */

  }


}