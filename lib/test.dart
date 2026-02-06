import 'package:flutter/material.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class PusherService {
  static final PusherChannelsFlutter _pusher =
      PusherChannelsFlutter.getInstance();
  
  static bool _isConnected = false;
  static bool _emergencyChannelSubscribed = false;  
  static bool _restartChannelSubscribed = false;    

  static Future<void> init({
    required String apiKey,
    required String cluster,
    required String orgId, 
    required Function(dynamic) onEmergencyBroadcast,
    required Function(dynamic) onRestartSignage,
  }) async {
    try {
      await _pusher.init(
        apiKey: apiKey,
        cluster: cluster,
        onConnectionStateChange: (currentState, previousState) {
          debugPrint('🔄 Pusher state: $previousState -> $currentState');
          
          if (currentState == 'CONNECTED') {
            _isConnected = true;
            debugPrint('✅ ✅ ✅ PUSHER IS NOW CONNECTED ✅ ✅ ✅');
            debugPrint('📡 OrgId: $orgId');
            
            // ✅ Check status when connected
            _printStatus();
          } else if (currentState == 'DISCONNECTED') {
            _isConnected = false;
            debugPrint('❌ ❌ ❌ PUSHER IS DISCONNECTED ❌ ❌ ❌');
          } else if (currentState == 'CONNECTING') {
            debugPrint('🔄 Pusher is connecting...');
          } else if (currentState == 'RECONNECTING') {
            debugPrint('🔄 Pusher is reconnecting...');
          }
        },
        onError: (message, code, error) {
          debugPrint('❌ Pusher error: $message (code: $code)');
          debugPrint('❌ Error details: $error');
        },
      );

      debugPrint('🔧 Subscribing to channels for orgId: $orgId');
  
   
      try {
        await _pusher.subscribe(
          channelName: 'emergency-broadcast-channel.$orgId',
          onEvent: (event) {  
            if (event.eventName == 'emergency-broadcast') {
              debugPrint('📡 Emergency broadcast received for org: $orgId');
              debugPrint('📦 Event data: ${event.data}');
              onEmergencyBroadcast(event.data);
            }
          },
        );
        _emergencyChannelSubscribed = true; 
        debugPrint('✅ Emergency channel subscribe() called');
      } catch (e) {
        _emergencyChannelSubscribed = false;
        debugPrint('❌ Emergency channel subscription error: $e');
      }

   
      try {
        await _pusher.subscribe(
          channelName: 'restart-signage-channel.$orgId',
          onEvent: (event) {  
            if (event.eventName == 'restart-signage') {
              debugPrint('🔄 Restart signage received for org: $orgId');
              debugPrint('📦 Event data: ${event.data}');
              onRestartSignage(event.data);
            }
          },
        );
        _restartChannelSubscribed = true; 
        debugPrint('✅ Restart channel subscribe() called');
      } catch (e) {
        _restartChannelSubscribed = false;
        debugPrint('❌ Restart channel subscription error: $e');
      }

      debugPrint('🔌 Attempting to connect Pusher...');
      await _pusher.connect();
      debugPrint('✅ Pusher connect() called successfully for orgId: $orgId');
      
      // ✅ Check status after longer delay (5 seconds)
      Future.delayed(const Duration(seconds: 5), () {
        _printStatus();
      });
      
      // ✅ Also check again after 10 seconds
      Future.delayed(const Duration(seconds: 10), () {
        debugPrint('🔍 ========== FINAL STATUS CHECK (10s) ==========');
        _printStatus();
      });
      
    } catch (e) {
      debugPrint('❌ Pusher init error: $e');
      _isConnected = false;
      _emergencyChannelSubscribed = false;
      _restartChannelSubscribed = false;
    }
  }

  // ✅ Helper method to print status
  static void _printStatus() {
    debugPrint('🔍 ========== STATUS CHECK ==========');
    debugPrint('🔍 Connection: ${_isConnected ? "CONNECTED ✅" : "NOT CONNECTED ❌"}');
    debugPrint('🔍 Emergency Channel: ${_emergencyChannelSubscribed ? "SUBSCRIBED ✅" : "NOT SUBSCRIBED ❌"}');
    debugPrint('🔍 Restart Channel: ${_restartChannelSubscribed ? "SUBSCRIBED ✅" : "NOT SUBSCRIBED ❌"}');
    debugPrint('🔍 ===================================');
  }

  // ✅ Getters
  static bool get isConnected => _isConnected;
  static bool get isEmergencyChannelSubscribed => _emergencyChannelSubscribed;
  static bool get isRestartChannelSubscribed => _restartChannelSubscribed;
  
  static void checkConnectionStatus() {
    debugPrint('🔍 ========== MANUAL STATUS CHECK ==========');
    _printStatus();
  }

  static Future<void> disconnect() async {
    try {
      await _pusher.disconnect();
      _isConnected = false;
      _emergencyChannelSubscribed = false;
      _restartChannelSubscribed = false;
      debugPrint('✅ Pusher disconnected');
    } catch (e) {
      debugPrint('❌ Pusher disconnect error: $e');
    }
  }
}