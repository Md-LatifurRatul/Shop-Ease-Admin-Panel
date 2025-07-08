import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient supabaseClient;

  AuthRepository({required this.supabaseClient});

  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    final response = await supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user != null) {
      return response.user;
    } else {
      throw Exception("Sign in failed");
    }
  }

  User? getCurrentUser() {
    return supabaseClient.auth.currentUser;
  }

  Future<void> signOut() async {
    await supabaseClient.auth.signOut();
  }
}
