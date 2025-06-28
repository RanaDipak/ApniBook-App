import 'package:flutter/material.dart';

import '../../../../core/constants/app_context.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/app_context_extensions.dart';
import '../../../client/presentation/pages/client_list_page.dart';


class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.homeTitle),
        backgroundColor: context.primaryColor,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: context.primaryColor,
              ),
              child: const Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
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
              onTap: () {
                
                
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text(AppStrings.stockBook),
              onTap: () {
                
                
              },
            ),
            ListTile(
              leading: const Icon(Icons.money_off),
              title: const Text(AppStrings.expenseBook),
              onTap: () {
                
                
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
              route: AppContext.clientBookRoute,
            ),
            _DashboardCard(
              icon: Icons.business,
              label: AppStrings.businessBook,
              route: AppContext.businessBookRoute,
            ),
            _DashboardCard(
              icon: Icons.inventory,
              label: AppStrings.stockBook,
              route: AppContext.stockBookRoute,
            ),
            _DashboardCard(
              icon: Icons.money_off,
              label: AppStrings.expenseBook,
              route: AppContext.expenseBookRoute,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {}, 
        icon: const Icon(Icons.help_outline),
        label: const Text('Help'),
        backgroundColor: context.primaryColor,
      ),
    );
  }
}


class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  const _DashboardCard(
      {required this.icon, required this.label, required this.route});

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
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ClientListPage()),
            );
          }
          
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: context.primaryColor),
            const SizedBox(height: 12),
            Text(
              label,
              style: context.body,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
