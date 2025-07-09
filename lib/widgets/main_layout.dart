import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_ease_admin/cubit/sidebar_navigation_cubit.dart';
import 'package:shop_ease_admin/features/views/banners/screens/banner_screen.dart';
import 'package:shop_ease_admin/features/views/dashboard/screens/dashboard_screen.dart';
import 'package:shop_ease_admin/features/views/products/screens/product_screen.dart';
import 'package:shop_ease_admin/widgets/side_bar_menu.dart';

class MainLayout extends StatelessWidget {
  MainLayout({super.key});

  final routeToIndex = {'/dashboard': 0, '/banners': 1, '/products': 2};

  final screens = [
    SizedBox.expand(child: DashboardScreen()),
    SizedBox.expand(child: BannerScreen()),
    SizedBox.expand(child: ProductScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          BlocSelector<SidebarNavigationCubit, String, String>(
            selector: (state) => state,
            builder: (context, currentRoute) {
              return SideBarMenu(
                selectRoute: currentRoute,
                onMenuItemSelected: (route) {
                  context.read<SidebarNavigationCubit>().selectRoute(route);
                },
              );
            },
          ),

          Expanded(
            child: BlocSelector<SidebarNavigationCubit, String, int>(
              selector: (route) => routeToIndex[route] ?? 0,
              builder: (context, index) {
                return IndexedStack(index: index, children: screens);
              },
            ),
          ),
        ],
      ),
    );
  }
}
