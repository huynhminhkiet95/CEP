import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

/// todo
class SocketIO {
  /// todo
  static const channelName = 'semigradsky.com/socket.io';

  /// todo
  static final MethodChannel _globalMethodChannel =
      new MethodChannel(channelName);

  /// todo
  static Future<SocketIO> createNewInstance(String uri) async {
    final String instanceId = await _globalMethodChannel.invokeMethod(
      'createNewInstance',
      {'uri': uri},
    );
    return new SocketIO._internal(
      instanceId: instanceId,
      uri: uri,
    );
  }

  /// todo
  final String uri;

  /// todo
  final String instanceId;

  /// todo
  final MethodChannel _methodChannel;

  /// todo
  SocketIO._internal({
    this.uri,
    this.instanceId,
  }) : _methodChannel = new MethodChannel("$channelName/$instanceId") {
    print("$channelName/$instanceId");
    _methodChannel.setMethodCallHandler((call) {
      if (call.method == 'handleData') {
        final String event = call.arguments['event'];
        final List<dynamic> arguments = call.arguments['arguments'];
        _handleData(event: event, arguments: arguments);
      }
    });
  }

  /// todo
  final Map<String, Map<String, Function>> _listeners = {};

  /// Manually opens the socket.
  connect() async {
    await _methodChannel.invokeMethod('connect');
  }

  /// Register a new handler for the given event.
  on(String event, Function listener) async {
    final listenerId = await _methodChannel.invokeMethod('on', {
      'event': event,
    });
    if (!_listeners.containsKey(event)) {
      _listeners[event] = new Map<String, Function>();
    }
    _listeners[event][listenerId] = listener;
  }

  /// todo
  off(String event, Function listener) async {
    if (!_listeners.containsKey(event)) return;
    String listenerId;
    for (var id in _listeners[event].keys) {
      if (_listeners[event][id] == listener) {
        listenerId = id;
        break;
      }
    }
    if (listenerId == null) return;
    await _methodChannel.invokeMethod('on', {
      'event': event,
      'listenerId': listenerId,
    });
  }

  /// An unique identifier for the socket session.
  ///
  /// Set after the [SocketIOEvent.connect] event is triggered,
  /// and updated after the [SocketIOEvent.reconnect] event.
  Future<String> get id async {
    return await _methodChannel.invokeMethod('id');
  }

  /// todo
  Future<bool> get isConnected async {
    return await _methodChannel.invokeMethod('isConnected');
  }

  /// Emits an event to the socket identified by the string name.
  emit(String event, List<dynamic> arguments) async {
    await _methodChannel.invokeMethod('emit', {
      'event': event,
      'arguments': arguments,
    });
  }

  emitevent(String event, dynamic arguments) async {
    await _methodChannel.invokeMethod('emit', {
      'event': event,
      'arguments': arguments,
    });
  }

  /// todo
  _handleData({
    String event,
    List<dynamic> arguments = const [],
  }) {
    arguments = arguments.map((argument) {
      if (argument is String) {
        try {
          final decodedJson = json.decode(argument);
          return decodedJson;
        } catch (_) {}
      }
      return argument;
    }).toList();
    if (_listeners.containsKey(event)) {
      _listeners[event].forEach((_, listener) {
        Function.apply(listener, arguments);
      });
    }
  }
}

/// todo
class SocketIOEvent {
  /// Fired upon a connection including a successful reconnection.
  static const connect = 'connect';

  /// Fired upon a connection error.
  static const connectError = 'connect_error';

  /// Fired upon a connection timeout.
  static const connectTimeout = 'connect_timeout';

  /// Fired when an error occurs.
  static const error = 'error';

  /// todo
  static const connecting = 'connecting';

  /// Fired upon a successful reconnection.
  static const reconnect = 'reconnect';

  /// Fired upon a reconnection attempt error.
  static const reconnectError = 'reconnect_error';

  /// todo
  static const reconnectFailed = 'reconnect_failed';

  /// Fired upon an attempt to reconnect.
  static const reconnectAttempt = 'reconnect_attempt';

  /// Fired upon an attempt to reconnect.
  static const reconnecting = 'reconnecting';

  /// Fired when a ping packet is written out to the server.
  static const ping = 'ping';

  /// Fired when a pong is received from the server.
  static const pong = 'pong';

  static const notification = 'notification';

  static const clientRequest = 'client-request';
}
