import 'package:flutter/material.dart';
import 'package:frontend_flutter/api/api_client.dart';
import 'package:frontend_flutter/api/event_service.dart';
import 'package:frontend_flutter/providers/auth_provider.dart';
import 'package:frontend_flutter/providers/event_provider.dart';
import 'package:frontend_flutter/providers/user_provider.dart';
import 'package:frontend_flutter/screens/auth/login_screen.dart';
import 'package:frontend_flutter/screens/events/events_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = FlutterSecureStorage();
  final token = await storage.read(key: 'auth_token');

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => ApiClient()),
        ProxyProvider<ApiClient, EventService>(
          update: (_, apiClient, __) => EventService(apiClient: apiClient),
        ),
        ChangeNotifierProxyProvider<EventService, EventProvider>(
          create: (_) => EventProvider(eventService: null),
          update: (_, eventService, eventProvider) =>
          eventProvider!..eventService = eventService,
        ),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MyApp(isLoggedIn: token != null),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      home: isLoggedIn ? const EventsListScreen() : const LoginScreen(),
      routes: {
        '/home': (context) => const EventsListScreen(),
      },
    );
  }
}