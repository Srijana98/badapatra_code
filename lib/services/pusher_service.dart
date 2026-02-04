import 'package:flutter/material.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class PusherService {
  static final PusherChannelsFlutter _pusher =
      PusherChannelsFlutter.getInstance();

  static Future<void> init({
    required String apiKey,
    required String cluster,
    required Function(dynamic) onEmergencyBroadcast,
    required Function(dynamic) onRestartSignage,
  }) async {
    try {
      await _pusher.init(
        apiKey: apiKey,
        cluster: cluster,
        onConnectionStateChange: (currentState, previousState) {
          debugPrint('Pusher state: $previousState -> $currentState');
        },
        onError: (message, code, error) {
          debugPrint('Pusher error: $message (code: $code)');
        },
      );

      // Subscribe with per-channel event handlers
      await _pusher.subscribe(
        channelName: 'emergency-broadcast-channel.RampurP',
        onEvent: (PusherEvent event) {
          if (event.eventName == 'emergency-broadcast') {
            onEmergencyBroadcast(event.data);
          }
        },
      );

      await _pusher.subscribe(
        channelName: 'restart-signage-channel.RampurP',
        onEvent: (PusherEvent event) {
          if (event.eventName == 'restart-signage') {
            onRestartSignage(event.data);
          }
        },
      );

      await _pusher.connect();
    } catch (e) {
      debugPrint('Pusher init error: $e');
    }
  }

  static Future<void> disconnect() async {
    await _pusher.unsubscribe(
      channelName: 'emergency-broadcast-channel.RampurP',
    );
    await _pusher.unsubscribe(channelName: 'restart-signage-channel.RampurP');
    await _pusher.disconnect();
  }
}