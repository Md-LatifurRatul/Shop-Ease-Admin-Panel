import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_ease_admin/features/views/auth/bloc/auth_bloc.dart';
import 'package:shop_ease_admin/features/views/auth/bloc/auth_event.dart';
import 'package:shop_ease_admin/features/views/auth/bloc/auth_state.dart';
import 'package:shop_ease_admin/features/views/auth/screens/login_screen.dart';
import 'package:shop_ease_admin/widgets/main_layout.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<AuthBloc>().add(AuthCheckRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading || state is AuthInitial) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is AuthAuthenticated) {
          return MainLayout();
        } else if (state is AuthUnauthenticated) {
          return LoginScreen();
        } else if (state is AuthFailure) {
          return Scaffold(body: Center(child: Text("Error: ${state.message}")));
        } else {
          return const Scaffold(body: Center(child: Text("Unknown state")));
        }
      },
    );
  }
}
