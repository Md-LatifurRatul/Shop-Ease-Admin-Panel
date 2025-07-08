import 'package:flutter/material.dart';
import 'package:shop_ease_admin/app.dart';
import 'package:shop_ease_admin/core/auth_url.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: AuthUrl.supabaseUrl,
    anonKey: AuthUrl.supabseKey,
  );

  runApp(const ShopEaseAdminApp());
}
