import 'package:flutter/material.dart';
import 'package:shop_ease_admin/features/views/dashboard/widgets/banner_list_section.dart';
import 'package:shop_ease_admin/features/views/dashboard/widgets/product_list_section.dart';
import 'package:shop_ease_admin/widgets/side_bar_menu.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String currentRoute = "/dashboard";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          //! Sidebar
          SideBarMenu(
            selectRoute: currentRoute,
            onMenuItemSelected: (route) {
              setState(() => currentRoute = route);
              Navigator.pushNamed(context, route);
            },
          ),

          //! Content Area
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildWelcome(),
                const SizedBox(height: 20),
                const BannerListSection(),
                const ProductListSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 60,
      color: Colors.deepPurple[50],
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.centerLeft,
      child: const Text(
        "Dashboard",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildWelcome() {
    return Expanded(
      flex: 0,
      child: Center(
        child: Text(
          "Welcome to ShopEase Admin Panel",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
