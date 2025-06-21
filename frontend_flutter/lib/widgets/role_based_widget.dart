import 'package:flutter/material.dart';
import 'package:frontend_flutter/providers/auth_provider.dart';
import 'package:provider/provider.dart';


class RoleBasedWidget extends StatelessWidget {
  final List<String> allowedRoles;
  final Widget child;

  const RoleBasedWidget({
    super.key,
    required this.allowedRoles,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userRole = authProvider.userRole;

    return userRole != null && allowedRoles.contains(userRole)
        ? child
        : const SizedBox.shrink();
  }
}