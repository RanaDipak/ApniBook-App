import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/service_locator.dart';
import '../../domain/entities/stock.dart';
import '../bloc/stock_bloc.dart';
import '../bloc/stock_state.dart';
import 'add_edit_stock_page.dart';

/// Page to display all stock items
class StockListPage extends StatelessWidget {
  const StockListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Rounded green header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 48, bottom: 24),
            decoration: const BoxDecoration(
              color: Color(0xFF3EC28F),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: const Row(
              children: [
                // Center content
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.stockBook,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Stock grid
          Expanded(
            child: BlocBuilder<StockBloc, StockState>(
              builder: (context, state) {
                if (state is StockLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is StockLoaded) {
                  final stocks = state.stocks;
                  if (stocks.isEmpty) {
                    return const Center(child: Text(AppStrings.noStockItems));
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1,
                      children: stocks
                          .map((stock) => _StockCard(stock: stock))
                          .toList(),
                    ),
                  );
                } else if (state is StockError) {
                  return Center(
                    child: Text(
                      '${AppStrings.errorPrefix}${state.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF3EC28F),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: serviceLocator.stockBloc,
                child: const AddEditStockPage(),
              ),
            ),
          );
        },
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }
}

class _StockCard extends StatelessWidget {
  final Stock stock;
  const _StockCard({required this.stock});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF3EC28F), width: 1.5),
      ),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: serviceLocator.stockBloc,
                child: AddEditStockPage(stock: stock),
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.warehouse, size: 48, color: Colors.teal[400]),
              const SizedBox(height: 12),
              Text(
                stock.productName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                stock.quantity.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
