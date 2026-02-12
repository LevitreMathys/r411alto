import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/home_screen.dart';
import 'screens/first_screen.dart';
import 'screens/account_created_screen.dart';
import 'screens/main_form_screen.dart';
import 'screens/profil_setting_screen.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  );

  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: '/first-screen',
      builder: (BuildContext context, GoRouterState state) {
        return const FirstScreen();
      },
    ),
    GoRoute(
      path: '/account-created',
      builder: (BuildContext context, GoRouterState state) {
        return const AccountCreatedScreen();
      },
    ),
    GoRoute(
      path: '/main-form',
      builder: (BuildContext context, GoRouterState state) {
        return const MainFormScreen();
      },
    ),
    GoRoute(
      path: '/profil-setting',
      builder: (BuildContext context, GoRouterState state) {
        return const ProfilSettingScreen();
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomeScreen(title: 'Home screen'),
    );
  }
}