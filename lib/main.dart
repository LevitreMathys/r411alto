import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:r411alto/App.dart';
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
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return App(body: child);
      },
      routes: [

        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(title: 'Home'),
        ),

        GoRoute(
          path: '/main-form',
          builder: (context, state) => const MainFormScreen(),
        ),

        GoRoute(
          path: '/profil-setting',
          builder: (context, state) => const ProfilSettingScreen(),
        ),
      ],
    ),

    // écrans hors menu
    GoRoute(
      path: '/first-screen',
      builder: (context, state) => const FirstScreen(),
    ),

    GoRoute(
      path: '/account-created',
      builder: (context, state) => const AccountCreatedScreen(),
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
    );
  }
}