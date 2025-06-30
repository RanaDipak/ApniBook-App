import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/app_context_extensions.dart';
import '../../domain/entities/client.dart';
import '../bloc/client_bloc.dart';

class AddEditClientPage extends StatefulWidget {
  final Client? client; // null for add, non-null for edit

  const AddEditClientPage({super.key, this.client});

  @override
  State<AddEditClientPage> createState() => _AddEditClientPageState();
}

class _AddEditClientPageState extends State<AddEditClientPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _businessTypeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill form if editing
    if (widget.client != null) {
      _nameController.text = widget.client!.name;
      _mobileController.text = widget.client!.mobileNumber;
      _businessTypeController.text = widget.client!.businessType;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _businessTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClientBloc(
        addClient: serviceLocator.addClient,
        updateClient: serviceLocator.updateClient,
        deleteClient: serviceLocator.deleteClient,
        getClients: serviceLocator.getClients,
        searchClients: serviceLocator.searchClients,
      ),
      child: _AddEditClientContent(
        formKey: _formKey,
        nameController: _nameController,
        mobileController: _mobileController,
        businessTypeController: _businessTypeController,
        client: widget.client,
      ),
    );
  }
}

class _AddEditClientContent extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController mobileController;
  final TextEditingController businessTypeController;
  final Client? client;

  const _AddEditClientContent({
    required this.formKey,
    required this.nameController,
    required this.mobileController,
    required this.businessTypeController,
    this.client,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClientBloc, ClientState>(
      listener: (context, state) {
        if (state is ClientSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppTheme.primaryColor,
            ),
          );
          Navigator.of(context).pop(true); // Return true to indicate success
        } else if (state is ClientError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
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
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        client == null
                            ? AppStrings.addClient
                            : AppStrings.editClient,
                        style: AppTheme.headline.copyWith(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Form content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(context.pagePadding),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Name Field
                        _buildTextField(
                          context,
                          controller: nameController,
                          label: AppStrings.clientName,
                          icon: Icons.person,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return AppStrings.pleaseEnterClientName;
                            }
                            if (value.trim().length < 2) {
                              return AppStrings.nameMinLength;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Mobile Number Field
                        _buildTextField(
                          context,
                          controller: mobileController,
                          label: AppStrings.mobileNumber,
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return AppStrings.pleaseEnterMobileNumber;
                            }
                            if (value.trim().length < 10) {
                              return AppStrings.mobileMinLength;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Business Type Field
                        _buildTextField(
                          context,
                          controller: businessTypeController,
                          label: AppStrings.businessType,
                          icon: Icons.business,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return AppStrings.pleaseEnterBusinessType;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),

                        // Submit Button
                        ElevatedButton(
                          onPressed: state is ClientLoading
                              ? null
                              : () => _submitForm(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            padding: const EdgeInsets.symmetric(
                              // vertical:
                              //     context.buttonHeight * 0.7, // Reduced height
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                context.cardRadius,
                              ),
                            ),
                          ),
                          child: state is ClientLoading
                              ? const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                )
                              : Text(
                                  client == null
                                      ? AppStrings.addClient
                                      : AppStrings.updateClient,
                                  style: AppTheme.body.copyWith(
                                    fontSize: 16, // Reduced from 18
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
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
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

  void _submitForm(BuildContext context) {
    if (formKey.currentState!.validate()) {
      final bloc = context.read<ClientBloc>();

      if (client == null) {
        // Add new client
        bloc.add(
          AddClientEvent(
            name: nameController.text.trim(),
            mobileNumber: mobileController.text.trim(),
            businessType: businessTypeController.text.trim(),
          ),
        );
      } else {
        // Update existing client
        final updatedClient = client!.copyWith(
          name: nameController.text.trim(),
          mobileNumber: mobileController.text.trim(),
          businessType: businessTypeController.text.trim(),
        );
        bloc.add(UpdateClientEvent(client: updatedClient));
      }
    }
  }
}
