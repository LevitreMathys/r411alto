import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:r411alto/App.dart';
import 'package:r411alto/screens/settings_screen.dart';
import 'package:r411alto/screens/chat_screen.dart';
import 'package:r411alto/services/onboarding_storage.dart';
import 'package:r411alto/theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/first_screen.dart';
import 'screens/account_created_screen.dart';
import 'screens/main_form_screen.dart';
import 'screens/profil_setting_screen.dart';
import 'screens/qr_code_screen.dart';
import 'screens/scan_qr_code_screen.dart';
import 'screens/easter_egg.dart';

const String urlBackend = "https://alto.samyn.ovh";

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(ProviderScope(child: MyApp()));
}

final GoRouter _router = GoRouter(
  initialLocation: '/',

  redirect: (context, state) async {
    final seen = await OnboardingStorage.isCompleted();

    // si l'utilisateur n'a PAS vu l'onboarding
    if (!seen && state.uri.path != '/first-screen') {
      return '/first-screen';
    }

    // s'il l'a déjà vu et tente d'y retourner
    if (seen && state.uri.path == '/first-screen') {
      return '/';
    }

    return null;
  },

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
          path: "/settings",
          builder: (context, state) => const SettingsScreen(title: 'Settings'),
        ),

        GoRoute(
          path: '/profil-setting',
          builder: (context, state) => const ProfilSettingScreen(),
        ),
      ],
    ),

    GoRoute(
      path: "/chat/:relationId",
      builder: (context, state) {
        final relationId = state.pathParameters['relationId']!;
        return ChatScreen(relationId: relationId);
      },
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
    GoRoute(
      path: '/easter-egg',
      builder: (BuildContext context, GoRouterState state) {
        return const EasterEgg();
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
      title: 'Alto',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
    );
  }
}
