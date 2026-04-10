import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavItem extends StatelessWidget {
  final IconData icon;
  final String name;
  final double size;

  const NavItem({
    super.key,
    required this.icon,
    required this.name,
    required this.size,
  });

  bool _isActive(BuildContext context) {
    final router = GoRouter.of(context);
    final location = router.routerDelegate.currentConfiguration.uri.toString();
    switch (name) {
      case 'message':
      case 'home':
        return location == '/';
      case 'profil':
        return location == '/profil-setting';
    }
    return false;
  }

  String _getLabel() {
    if (name == 'message') return 'Liste des contacts';
    if (name == 'profil') return 'Profil';
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final isActive = _isActive(context);
    final theme = Theme.of(context);
    final iconColor = isActive
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurfaceVariant;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: isActive
              ? null
              : () {
                  ChangeScreen(context);
                },
          icon: Icon(icon, color: iconColor),
          iconSize: size,
        ),
        if (isActive)
          Text(
            _getLabel(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }

  void ChangeScreen(BuildContext context) {
    switch (name) {
      case 'message':
      case 'home':
        context.go('/');
        break;
      case 'profil':
        context.go('/profil-setting');
        break;
    }
  }
}
