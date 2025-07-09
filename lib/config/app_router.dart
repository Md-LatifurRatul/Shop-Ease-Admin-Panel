import 'package:flutter/material.dart';
import 'package:shop_ease_admin/features/views/auth/screens/auth_gate.dart';
import 'package:shop_ease_admin/features/views/auth/screens/login_screen.dart';
import 'package:shop_ease_admin/features/views/banners/models/banner_model.dart';
import 'package:shop_ease_admin/features/views/banners/screens/edit_banner_screen.dart';
import 'package:shop_ease_admin/features/views/products/models/product_model.dart';
import 'package:shop_ease_admin/features/views/products/screens/edit_product_screen.dart';

class AppRouter {
  static const String authGate = "/";
  static const String login = "/login";
  static const String editBanner = "/edit-banner";
  static const String editProduct = "/edit-product";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case authGate:
        return MaterialPageRoute(builder: (_) => const AuthGate());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case editBanner:
        final banner = settings.arguments as BannerModel;
        return MaterialPageRoute(
          builder: (_) => EditBannerScreen(banner: banner),
        );
      case editProduct:
        final product = settings.arguments as ProductModel;
        return MaterialPageRoute(
          builder: (_) => EditProductScreen(product: product),
        );
      default:
        return MaterialPageRoute(
          builder:
              (_) =>
                  const Scaffold(body: Center(child: Text("No Route Defined"))),
        );
    }
  }
}
