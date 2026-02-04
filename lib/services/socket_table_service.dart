import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketTableService {
  static final SocketTableService _instance = SocketTableService._internal();
  factory SocketTableService() => _instance;
  SocketTableService._internal();

  IO.Socket? _socket;

  // Event callbacks
  Function(String uniqueId)? _onUniqueIdReceived;
  Function(dynamic data)? _onTableUpdate;
  Function(String videoId)? _onYoutubeCommand;
  Function()? _onAdminRestart;


  void connect({required String url, String? pushingKey}) {
    if (_socket != null && _socket!.connected) return;

    final query = <String, dynamic>{};
    if (pushingKey != null) query['key'] = pushingKey;

    _socket = IO.io(
      url,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableReconnection()
          .setQuery(query)
          .disableAutoConnect()
          .build(),
    );

    _socket!.connect();

    _socket!
      ..onConnect((_) {
        print('✅ SOCKET CONNECTED');
      })
      ..onDisconnect((_) {
        print('❌ SOCKET DISCONNECTED');
      })
      // SERVER → SEND UNIQUE ID
      ..on('uniqueId', (data) {
        if (data is String) {
          print("📩 Unique ID received: $data");
          _onUniqueIdReceived?.call(data);
        }
      })
      // SERVER → SEND TABLE DATA
      ..on('tableData', (data) {
        print("📩 Table update received");
        _onTableUpdate?.call(data);
      })
      // SERVER → COMMAND TO PLAY YOUTUBE VIDEO
      ..on('youtubePlay', (data) {
        if (data is String) {
          print("📩 YouTube play command: $data");
          _onYoutubeCommand?.call(data);
        }
      })
      // SERVER → ADMIN RESTART
      ..on('adminRestart', (_) {
        print("📩 Admin restart command");
        _onAdminRestart?.call();
      });
  }

  // Callback setters
  void onUniqueIdReceived(Function(String id) fn) => _onUniqueIdReceived = fn;
  void onTableUpdate(Function(dynamic data) fn) => _onTableUpdate = fn;
  void onYoutubeCommand(Function(String videoId) fn) => _onYoutubeCommand = fn;
  void onAdminRestart(Function() fn) => _onAdminRestart = fn;

  void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }
}