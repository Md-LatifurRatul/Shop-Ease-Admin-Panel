import 'package:flutter/material.dart';
import 'package:shop_ease_admin/features/views/auth/widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              if (constraints.maxWidth > 800)
                Expanded(
                  child: Container(
                    color: Colors.indigo.shade900,
                    child: Center(
                      child: Text(
                        "ShopEase Admin",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),

              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 400),
                    child: const LoginForm(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
