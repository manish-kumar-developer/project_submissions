import 'package:flutter/material.dart';
import 'package:frontend_flutter/api/api_client.dart';
import 'package:frontend_flutter/api/event_service.dart';
import 'package:frontend_flutter/providers/auth_provider.dart';
import 'package:frontend_flutter/providers/event_provider.dart';
import 'package:frontend_flutter/providers/user_provider.dart';
import 'package:frontend_flutter/screens/events/events_list_screen.dart';
import 'package:frontend_flutter/screens/home_screen.dart';
import 'package:frontend_flutter/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
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
      child: MaterialApp(
        title: 'Event Manager',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
        ),
        home: const SplashScreen(), // Set splash as initial screen
        routes: {
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}