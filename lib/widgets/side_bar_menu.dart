import 'package:flutter/material.dart';

class SideBarMenu extends StatelessWidget {
  const SideBarMenu({
    super.key,
    required this.selectRoute,
    required this.onMenuItemSelected,
  });
  final String selectRoute;
  final Function(String route) onMenuItemSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.deepPurple,
      child: Column(
        children: [
          const DrawerHeader(
            child: Text(
              "ShopEase Admin",
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
          ),
          _buildMenuItem(
            icon: Icons.dashboard,
            title: "Dashboard",
            routeName: "/dashboard",
          ),

          _buildMenuItem(
            icon: Icons.image,
            title: "Banners",
            routeName: "/banners",
          ),
          _buildMenuItem(
            icon: Icons.shopping_bag,
            title: "Products",
            routeName: "/products",
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String routeName,
  }) {
    final bool isSelected = selectRoute == routeName;
    return ListTile(
      leading: Icon(icon, color: Colors.white),

      title: Text(title, style: const TextStyle(color: Colors.white)),
      tileColor: isSelected ? Colors.deepPurple.shade700 : Colors.deepPurple,
      onTap: () => onMenuItemSelected(routeName),
    );
  }
}
