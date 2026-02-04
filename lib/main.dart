import 'package:flutter/material.dart';
import 'services/socket_table_service.dart';
import 'services/hive_service.dart';
import 'login_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';  
import 'package:nagarikbadapatra/l10n/app_localizations.dart';


final socketService = SocketTableService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();

  // ✅ NEW API ENDPOINT
  socketService.connect(
    url: 'https://digitalbadapatra.com',
    pushingKey: 'YOUR_KEY',
  );

  socketService.onUniqueIdReceived((uniqueId) {
    print("🔐 Unique ID from server: $uniqueId");
  });

  socketService.onTableUpdate((data) {
    print("📊 Table updated: $data");
  });

  socketService.onAdminRestart(() {
    print("🔁 ========== SOCKET: ADMIN RESTART RECEIVED ==========");
    AppRestartManager.instance.triggerRestart();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nagarik Wada Patra',
      debugShowCheckedModeBanner: false,

      // ✅ ADD THESE LINES FOR LOCALIZATION:
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('ne', ''), // Nepali
      ],
      locale: const Locale('ne', ''),
      home: const LoginPage(),
    );
  }
}




class AppRestartManager {
  static final AppRestartManager _instance = AppRestartManager._internal();
  static AppRestartManager get instance => _instance;
  AppRestartManager._internal();

  final List<VoidCallback> _cleanupCallbacks = [];
  VoidCallback? _reloadCallback;

  void registerCleanup(VoidCallback cleanup) {
    _cleanupCallbacks.add(cleanup);
  }

  void removeCleanup(VoidCallback cleanup) {
    _cleanupCallbacks.remove(cleanup);
  }

  void registerReloadCallback(VoidCallback callback) {
    _reloadCallback = callback;
  }

  void triggerRestart() {
    print("🔄 ========== ADMIN RESTART TRIGGERED ==========");

    // Execute all cleanups
    for (final cleanup in List.from(_cleanupCallbacks)) {
      try {
        cleanup();
      } catch (e) {
        print("❌ Cleanup error: $e");
      }
    }

    _cleanupCallbacks.clear();

    // Reload homepage data
    _reloadCallback?.call();

    print("✅ ========== RESTART COMPLETED ==========");
  }
}



