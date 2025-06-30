import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/app_context_extensions.dart';
import '../../../client/presentation/pages/client_list_page.dart';
import '../../../client/presentation/pages/delete_confirmation_page.dart';
import '../../../stock/presentation/bloc/stock_event.dart';
import '../../../stock/presentation/pages/stock_list_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DateTime? _lastBackPressTime;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            AppStrings.homeTitle,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: context.primaryColor,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ), // Set drawer icon color to white
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: context.primaryColor),
                child: const Text(
                  AppStrings.menu,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ), // Reduced font size from 24 to 20
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text(AppStrings.clientBook),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ClientListPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.business),
                title: const Text(AppStrings.businessBook),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.inventory),
                title: const Text(AppStrings.stockBook),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: serviceLocator.stockBloc
                          ..add(const LoadStocks()),
                        child: const StockListPage(),
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.money_off),
                title: const Text(AppStrings.expenseBook),
                onTap: () {},
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: const Text(AppStrings.deleteClient),
                onTap: () {
                  Navigator.of(context).pop(); // Close drawer
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const DeleteConfirmationPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        body: Padding(
          padding: EdgeInsets.all(context.pagePadding),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: const [
              _DashboardCard(
                icon: Icons.person,
                label: AppStrings.clientBook,
                route: AppRoutes.clientBookRoute,
              ),
              _DashboardCard(
                icon: Icons.business,
                label: AppStrings.businessBook,
                route: AppRoutes.businessBookRoute,
              ),
              _DashboardCard(
                icon: Icons.inventory,
                label: AppStrings.stockBook,
                route: AppRoutes.stockBookRoute,
              ),
              _DashboardCard(
                icon: Icons.money_off,
                label: AppStrings.expenseBook,
                route: AppRoutes.expenseBookRoute,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          icon: const Icon(Icons.help_outline),
          label: const Text(AppStrings.help),
          backgroundColor: context.primaryColor,
        ),
      ),
    );
  }

  /// Handles back button press on dashboard with double-tap to exit
  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    if (_lastBackPressTime != null &&
        now.difference(_lastBackPressTime!) < const Duration(seconds: 2)) {
      // Double back press - exit app immediately
      SystemNavigator.pop();
      return false;
    }

    // First back press - show confirmation dialog
    _lastBackPressTime = now;

    final shouldExit = await _showExitConfirmationDialog();

    if (shouldExit) {
      SystemNavigator.pop();
    }

    return false; // Prevent default back behavior
  }

  /// Shows exit confirmation dialog for dashboard
  Future<bool> _showExitConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text(AppStrings.exitApp),
              content: const Text(AppStrings.exitConfirmationMessage),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(false); // No - stay in app
                  },
                  child: const Text(AppStrings.no),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(true); // Yes - exit app
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text(AppStrings.yes),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  const _DashboardCard({
    required this.icon,
    required this.label,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.cardRadius),
        side: BorderSide(color: context.primaryColor.withOpacity(0.3)),
      ),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(context.cardRadius),
        onTap: () {
          if (label == AppStrings.clientBook) {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const ClientListPage()));
          } else if (label == AppStrings.stockBook) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: serviceLocator.stockBloc..add(const LoadStocks()),
                  child: const StockListPage(),
                ),
              ),
            );
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: context.primaryColor),
            const SizedBox(height: 12),
            Text(label, style: context.body, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
