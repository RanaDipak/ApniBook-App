import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/app_context_extensions.dart';
import '../../../client/domain/entities/client.dart';
import '../../domain/entities/transaction.dart';
import '../bloc/transaction_bloc.dart';

class AddTransactionPage extends StatefulWidget {
  final Client client;
  final String? preSelectedType;

  const AddTransactionPage({
    super.key,
    required this.client,
    this.preSelectedType,
  });

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator.createTransactionBloc(),
      child: _AddTransactionContent(
        client: widget.client,
        preSelectedType: widget.preSelectedType,
      ),
    );
  }
}

class _AddTransactionContent extends StatefulWidget {
  final Client client;
  final String? preSelectedType;

  const _AddTransactionContent({required this.client, this.preSelectedType});

  @override
  State<_AddTransactionContent> createState() => _AddTransactionContentState();
}

class _AddTransactionContentState extends State<_AddTransactionContent> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedType = AppStrings.paid; // Default to Paid
  bool _isLoading = false;

  final List<String> _transactionTypes = [AppStrings.paid, AppStrings.received];

  @override
  void initState() {
    super.initState();
    // Set pre-selected type if provided
    if (widget.preSelectedType != null) {
      _selectedType = widget.preSelectedType!;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionBloc, TransactionState>(
      listener: (context, state) {
        if (state is TransactionLoading) {
          setState(() => _isLoading = true);
        } else if (state is TransactionAdded) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AppStrings.transactionAddedSuccess),
              backgroundColor: AppTheme.primaryColor,
            ),
          );
          Navigator.of(context).pop(true); // Return true to indicate success
        } else if (state is TransactionError) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${AppStrings.failedToAddTransaction}${state.message}',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Column(
            children: [
              // Header with title
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 48, bottom: 16),
                decoration: const BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Center(
                  child: Text(
                    AppStrings.addTransaction,
                    style: AppTheme.headline.copyWith(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),

              // Form content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(context.pagePadding),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Client Info Card
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              context.cardRadius,
                            ),
                            side: const BorderSide(
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: context.iconSize,
                                  backgroundColor: AppTheme.primaryColor,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: context.iconSize,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.client.name,
                                        style: AppTheme.body.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        widget.client.mobileNumber,
                                        style: AppTheme.caption.copyWith(
                                          color: AppTheme.textColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Transaction Type Dropdown
                        _buildDropdownField(
                          context,
                          label: AppStrings.transactionType,
                          icon: Icons.category,
                          value: _selectedType,
                          items: _transactionTypes,
                          onChanged: (value) {
                            setState(() {
                              _selectedType = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 16),

                        // Amount Field
                        _buildTextField(
                          context,
                          controller: _amountController,
                          label: AppStrings.amount,
                          icon: Icons.attach_money,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return AppStrings.enterAmount;
                            }
                            if (double.tryParse(value) == null) {
                              return AppStrings.validAmount;
                            }
                            if (double.parse(value) <= 0) {
                              return AppStrings.amountGreaterThanZero;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Date Picker Field
                        _buildDatePickerField(context),
                        const SizedBox(height: 16),

                        // Note Field
                        _buildTextField(
                          context,
                          controller: _noteController,
                          label: AppStrings.note,
                          icon: Icons.note,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 32),

                        // Submit Button
                        ElevatedButton(
                          onPressed: _isLoading ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                context.cardRadius,
                              ),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  AppStrings.addTransaction,
                                  style: AppTheme.body.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: AppTheme.primaryColor,
          size: context.iconSize,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.cardRadius),
          borderSide: const BorderSide(color: AppTheme.primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.cardRadius),
          borderSide: const BorderSide(color: AppTheme.primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.cardRadius),
          borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.cardRadius),
          borderSide: const BorderSide(color: Colors.red),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  Widget _buildDropdownField(
    BuildContext context, {
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: AppTheme.primaryColor,
          size: context.iconSize,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.cardRadius),
          borderSide: const BorderSide(color: AppTheme.primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.cardRadius),
          borderSide: const BorderSide(color: AppTheme.primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.cardRadius),
          borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(value: item, child: Text(item));
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDatePickerField(BuildContext context) {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime.now().add(const Duration(days: 1)),
        );
        if (picked != null && picked != _selectedDate) {
          setState(() {
            _selectedDate = picked;
          });
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: AppStrings.date,
          prefixIcon: Icon(
            Icons.calendar_today,
            color: AppTheme.primaryColor,
            size: context.iconSize,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(context.cardRadius),
            borderSide: const BorderSide(color: AppTheme.primaryColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(context.cardRadius),
            borderSide: const BorderSide(color: AppTheme.primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(context.cardRadius),
            borderSide: const BorderSide(
              color: AppTheme.primaryColor,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        child: Text(
          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
          style: AppTheme.body,
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Create transaction based on type
      final amount = double.parse(_amountController.text.trim());
      final received = _selectedType == AppStrings.received
          ? amount.toInt()
          : 0;
      final paid = _selectedType == AppStrings.paid ? amount.toInt() : 0;

      // Create transaction entity
      final transaction = Transaction(
        id: '', // Will be generated by Firestore
        clientId: widget.client.id,
        dateTime: _selectedDate,
        received: received,
        paid: paid,
      );

      // Add transaction using bloc
      context.read<TransactionBloc>().add(AddTransactionEvent(transaction));
    }
  }
}
