import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/stock.dart';
import '../bloc/stock_bloc.dart';
import '../bloc/stock_event.dart';
import '../bloc/stock_state.dart';

/// Page for adding or editing stock items
class AddEditStockPage extends StatefulWidget {
  final Stock? stock; // null for add, non-null for edit

  const AddEditStockPage({super.key, this.stock});

  @override
  State<AddEditStockPage> createState() => _AddEditStockPageState();
}

class _AddEditStockPageState extends State<AddEditStockPage> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill form if editing
    if (widget.stock != null) {
      _productNameController.text = widget.stock!.productName;
      _quantityController.text = widget.stock!.quantity.toString();
      _priceController.text = widget.stock!.pricePerUnit.toString();
    }
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.stock == null ? AppStrings.addStock : AppStrings.editStock,
        ),
      ),
      body: BlocListener<StockBloc, StockState>(
        listener: (context, state) {
          if (state is StockSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is StockError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Product Name Field
                TextFormField(
                  controller: _productNameController,
                  decoration: const InputDecoration(
                    labelText: AppStrings.productName,
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.inventory),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppStrings.pleaseEnterProductName;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Quantity Field
                TextFormField(
                  controller: _quantityController,
                  decoration: const InputDecoration(
                    labelText: AppStrings.quantity,
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.numbers),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppStrings.pleaseEnterQuantity;
                    }
                    final quantity = int.tryParse(value);
                    if (quantity == null || quantity <= 0) {
                      return AppStrings.pleaseEnterValidQuantity;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Price Per Unit Field
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: AppStrings.pricePerUnit,
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppStrings.pleaseEnterPricePerUnit;
                    }
                    final price = double.tryParse(value);
                    if (price == null || price <= 0) {
                      return AppStrings.pleaseEnterValidPrice;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Save Button
                ElevatedButton(
                  onPressed: _saveStock,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    widget.stock == null
                        ? AppStrings.addStock
                        : AppStrings.updateStock,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Save or update stock item
  void _saveStock() {
    if (_formKey.currentState!.validate()) {
      final productName = _productNameController.text.trim();
      final quantity = int.parse(_quantityController.text);
      final pricePerUnit = double.parse(_priceController.text);

      if (widget.stock == null) {
        // Add new stock
        context.read<StockBloc>().add(
          AddStock(
            productName: productName,
            quantity: quantity,
            pricePerUnit: pricePerUnit,
          ),
        );
      } else {
        // Update existing stock
        context.read<StockBloc>().add(
          UpdateStock(
            id: widget.stock!.id,
            productName: productName,
            quantity: quantity,
            pricePerUnit: pricePerUnit,
          ),
        );
      }
    }
  }
}
