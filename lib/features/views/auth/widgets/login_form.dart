import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_ease_admin/config/app_router.dart';
import 'package:shop_ease_admin/features/views/auth/bloc/auth_bloc.dart';
import 'package:shop_ease_admin/features/views/auth/bloc/auth_event.dart';
import 'package:shop_ease_admin/features/views/auth/bloc/auth_state.dart';
import 'package:shop_ease_admin/features/views/auth/cubit/password_visibility_cubit.dart';
import 'package:shop_ease_admin/widgets/snack_message.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          SnackMessage.showSnackMessage(context, "Login Success");
          Navigator.pushNamed(context, AppRouter.dashboard);
        } else if (state is AuthFailure) {
          SnackMessage.showSnackMessage(context, state.message);
          log(state.message);
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Admin Login",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.indigo.shade900,
              ),
            ),
            const SizedBox(height: 30),

            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.mail),
                border: OutlineInputBorder(),
              ),
              validator:
                  (value) =>
                      value == null || value.isEmpty
                          ? 'Enter your email'
                          : null,
            ),
            const SizedBox(height: 20),

            BlocBuilder<PasswordVisibilityCubit, bool>(
              builder: (context, obsecurePassword) {
                return TextFormField(
                  controller: _passwordController,
                  obscureText: obsecurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obsecurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        context.read<PasswordVisibilityCubit>().toggle();
                      },
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Enter your password'
                              : null,
                );
              },
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed:
                        state is AuthLoading
                            ? null
                            : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                  AuthSignInRequested(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text.trim(),
                                  ),
                                );
                              }
                            },

                    child:
                        state is AuthLoading
                            ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            )
                            : const Text(
                              "Login",
                              style: TextStyle(color: Colors.white),
                            ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
