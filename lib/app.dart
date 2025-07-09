import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_ease_admin/config/app_router.dart';
import 'package:shop_ease_admin/core/app_theme.dart';
import 'package:shop_ease_admin/cubit/image_picker_cubit.dart';
import 'package:shop_ease_admin/data/repositories/auth_repository.dart';
import 'package:shop_ease_admin/data/repositories/banner_repository.dart';
import 'package:shop_ease_admin/data/repositories/product_repository.dart';
import 'package:shop_ease_admin/features/views/auth/bloc/auth_bloc.dart';
import 'package:shop_ease_admin/features/views/auth/cubit/password_visibility_cubit.dart';
import 'package:shop_ease_admin/features/views/banners/bloc/banner_bloc.dart';
import 'package:shop_ease_admin/features/views/products/bloc/product_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ShopEaseAdminApp extends StatelessWidget {
  const ShopEaseAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => BannerBloc(BannerRepository())),
        BlocProvider(create: (_) => ProductBloc(ProductRepository())),

        BlocProvider(
          create:
              (_) => AuthBloc(
                AuthRepository(supabaseClient: Supabase.instance.client),
              ),
        ),

        BlocProvider(create: (_) => PasswordVisibilityCubit()),
        BlocProvider(create: (_) => ImagePickerCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "ShopEase Admin Panel",
        theme: AppTheme.lightTheme,
        initialRoute: AppRouter.authGate,
        // initialRoute: AppRouter.dashboard,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
