import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_ease_admin/cubit/sidebar_navigation_cubit.dart';
import 'package:shop_ease_admin/features/views/auth/bloc/auth_bloc.dart';
import 'package:shop_ease_admin/features/views/auth/bloc/auth_event.dart';
import 'package:shop_ease_admin/features/views/auth/bloc/auth_state.dart';
import 'package:shop_ease_admin/features/views/auth/screens/login_screen.dart';
import 'package:shop_ease_admin/widgets/main_layout.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    Future.microtask(() {
      context.read<AuthBloc>().add(AuthCheckRequested());
    });

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          context.read<SidebarNavigationCubit>().selectRoute('/dashboard');
          return MainLayout();
        } else if (state is AuthUnauthenticated) {
          return LoginScreen();
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
