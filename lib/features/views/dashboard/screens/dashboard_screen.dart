import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_ease_admin/config/app_router.dart';
import 'package:shop_ease_admin/cubit/sidebar_navigation_cubit.dart';
import 'package:shop_ease_admin/features/views/auth/bloc/auth_bloc.dart';
import 'package:shop_ease_admin/features/views/auth/bloc/auth_event.dart';
import 'package:shop_ease_admin/features/views/auth/bloc/auth_state.dart';
import 'package:shop_ease_admin/features/views/dashboard/widgets/banner_list_section.dart';
import 'package:shop_ease_admin/features/views/dashboard/widgets/product_list_section.dart';
import 'package:shop_ease_admin/widgets/confirm_alert.dart';
import 'package:shop_ease_admin/widgets/side_bar_menu.dart';
import 'package:shop_ease_admin/widgets/snack_message.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => current is AuthUnauthenticated,
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushReplacementNamed(context, AppRouter.login);
        }
      },
      child: Scaffold(
        body: Row(
          children: [
            //! Sidebar
            BlocSelector<SidebarNavigationCubit, String, String>(
              selector: (state) => state,
              builder: (context, currentRoute) {
                return SideBarMenu(
                  selectRoute: currentRoute,
                  onMenuItemSelected: (route) {
                    context.read<SidebarNavigationCubit>().selectRoute(route);
                    Navigator.pushNamed(context, route);
                  },
                );
              },
            ),
            //! Content Area
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 20),
                  _buildWelcome(context),
                  const SizedBox(height: 20),
                  const BannerListSection(),
                  const ProductListSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.deepPurple[50],
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          const Text(
            "Dashboard",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Spacer(),

          ElevatedButton.icon(
            icon: const Icon(Icons.logout),
            label: const Text("Logout"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              ConfirmAlert.showConfirmAlertDialogue(
                context,
                title: "Log-Out Admin",
                content: 'Are you sure you want to log-out?',
                confirmString: "Yes, Log-out",
                onPressed: () {
                  Navigator.pop(context);
                  context.read<AuthBloc>().add(AuthSignOutRequested());
                  SnackMessage.showSnackMessage(
                    context,
                    "Log-out successfuly!",
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWelcome(BuildContext context) {
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
