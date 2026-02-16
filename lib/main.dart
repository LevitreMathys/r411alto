import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:r411alto/App.dart';
import 'screens/home_screen.dart';
import 'screens/first_screen.dart';
import 'screens/account_created_screen.dart';
import 'screens/main_form_screen.dart';
import 'screens/profil_setting_screen.dart';
import 'screens/QR_code_screen.dart';
import 'screens/scan_qr_code_screen.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  );

  runApp(ProviderScope(child: MyApp()));
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
      path: '/sign-up',
      builder: (context, state) => const MainFormScreen(),
    ),

    GoRoute(
      path: '/account-created',
      builder: (context, state) => const AccountCreatedScreen(),
    ),
    GoRoute(
      path: '/qr-code',
      builder: (BuildContext context, GoRouterState state) {
        return const QRCodeScreen();
      },
    ),
    GoRoute(
      path: '/scan-qr-code',
      builder: (BuildContext context, GoRouterState state) {
        return const ScanQRCodeScreen();
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
    );
  }
}