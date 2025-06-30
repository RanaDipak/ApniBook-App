import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/app_context_extensions.dart';
import '../../domain/entities/client.dart';
import '../bloc/client_bloc.dart';

class DeleteConfirmationPage extends StatefulWidget {
  const DeleteConfirmationPage({super.key});

  @override
  State<DeleteConfirmationPage> createState() => _DeleteConfirmationPageState();
}

class _DeleteConfirmationPageState extends State<DeleteConfirmationPage> {
  final _formKey = GlobalKey<FormState>();
  final _clientIdController = TextEditingController();
  final _searchController = TextEditingController();
  bool _isLoading = false;
  String? _clientName; 
  String? _selectedClientId; 
  List<Client> _allClients = []; 
  List<Client> _filteredClients = []; 
  bool _showClientList = false; 
  ClientBloc? _clientBloc; 

  @override
  void initState() {
    super.initState();
    _loadAllClients(); 
  }

  @override
  void dispose() {
    _clientIdController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  
  Future<void> _loadAllClients() async {
    try {
      setState(() => _isLoading = true);

      final clients = await serviceLocator.clientRepository.getClients();

      setState(() {
        _allClients = clients;
        _filteredClients = clients;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppStrings.errorLoadingClientsForDelete}$e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  
  void _filterClients(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        _filteredClients = _allClients;
        _showClientList = false;
      });
      return;
    }

    final filtered = _allClients.where((client) {
      final name = client.name.toLowerCase();
      final mobile = client.mobileNumber.toLowerCase();
      final searchQuery = query.toLowerCase();

      return name.contains(searchQuery) ||
          mobile.contains(searchQuery) ||
          client.id.toLowerCase().contains(searchQuery);
    }).toList();

    setState(() {
      _filteredClients = filtered;
      _showClientList = true;
    });
  }

  
  void _selectClient(Client client) {
    setState(() {
      _selectedClientId = client.id;
      _clientName = client.name;
      _clientIdController.text = client.id;
      _searchController.text = client.name;
      _showClientList = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${AppStrings.clientSelected}${client.name} (ID: ${client.id})',
        ),
        backgroundColor: AppTheme.primaryColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        _clientBloc = ClientBloc(
          addClient: serviceLocator.addClient,
          updateClient: serviceLocator.updateClient,
          deleteClient: serviceLocator.deleteClient,
          getClients: serviceLocator.getClients,
          searchClients: serviceLocator.searchClients,
        );
        return _clientBloc!;
      },
      child: Builder(
        builder: (context) => BlocConsumer<ClientBloc, ClientState>(
          listener: (context, state) {
            if (state is ClientLoading) {
              setState(() => _isLoading = true);
            } else if (state is ClientSuccess) {
              setState(() => _isLoading = false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppTheme.primaryColor,
                ),
              );
              Navigator.of(
                context,
              ).pop(true); 
            } else if (state is ClientError) {
              setState(() => _isLoading = false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${AppStrings.deleteFailed}${state.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
              body: Column(
                children: [
                  
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 48, bottom: 8),
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      children: [
                        
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    AppStrings.deleteConfirmation,
                                    style: AppTheme.headline.copyWith(
                                      color: Colors.white,
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 48,
                              ), 
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),

                  
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(context.pagePadding),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.warning_amber_rounded,
                                  size: context.iconSize * 3,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            
                            Text(
                              AppStrings.deleteActionCannotBeUndone,
                              textAlign: TextAlign.center,
                              style: AppTheme.body.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(height: 32),

                            
                            _buildSearchField(
                              context,
                              controller: _searchController,
                              label: AppStrings.searchClientByCriteria,
                              icon: Icons.search,
                              onChanged: _filterClients,
                              hintText: AppStrings.searchClientHint,
                            ),
                            const SizedBox(height: 16),

                            
                            if (_showClientList &&
                                _filteredClients.isNotEmpty) ...[
                              Container(
                                constraints: const BoxConstraints(
                                  maxHeight: 200,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppTheme.primaryColor,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    context.cardRadius,
                                  ),
                                ),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _filteredClients.length,
                                  itemBuilder: (context, index) {
                                    final client = _filteredClients[index];
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: AppTheme.primaryColor,
                                        child: Text(
                                          client.name[0].toUpperCase(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        client.name,
                                        style: AppTheme.body.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      subtitle: Text(
                                        '${client.mobileNumber} • ID: ${client.id}',
                                        style: AppTheme.caption,
                                      ),
                                      onTap: () => _selectClient(client),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],

                            
                            _buildTextField(
                              context,
                              controller: _clientIdController,
                              label: AppStrings.clientId,
                              icon: Icons.person_search,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return AppStrings.pleaseEnterClientId;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),

                            
                            ElevatedButton(
                              onPressed: _isLoading ? null : _searchClient,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
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
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : Text(
                                      AppStrings.searchClient,
                                      style: AppTheme.body.copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 24),

                            
                            if (_clientName != null) ...[
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    context.cardRadius,
                                  ),
                                  side: const BorderSide(color: Colors.red),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        size: context.iconSize * 2,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        _clientName!,
                                        style: AppTheme.body.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'ID: ${_clientIdController.text.trim()}',
                                        style: AppTheme.caption.copyWith(
                                          color: AppTheme.textColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),

                              
                              Text(
                                AppStrings.confirmDelete,
                                textAlign: TextAlign.center,
                                style: AppTheme.body.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 24),

                              
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: _isLoading
                                          ? null
                                          : _confirmDelete,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            context.cardRadius,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        AppStrings.yes,
                                        style: AppTheme.body.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: _isLoading
                                          ? null
                                          : _cancelDelete,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            context.cardRadius,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        AppStrings.no,
                                        style: AppTheme.body.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],

                            
                            if (_allClients.isNotEmpty) ...[
                              const SizedBox(height: 24),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(
                                    context.cardRadius,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.people,
                                      color: AppTheme.primaryColor,
                                      size: context.iconSize,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${AppStrings.totalClients}${_allClients.length}',
                                      style: AppTheme.body.copyWith(
                                        color: AppTheme.primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Function(String) onChanged,
    String? hintText,
  }) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(
          icon,
          color: AppTheme.primaryColor,
          size: context.iconSize,
        ),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  controller.clear();
                  onChanged('');
                },
              )
            : null,
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

  void _searchClient() async {
    if (_formKey.currentState!.validate()) {
      final clientId = _clientIdController.text.trim();

      try {
        setState(() => _isLoading = true);

        
        final client = await serviceLocator.clientRepository.getClient(
          clientId,
        );

        if (client != null) {
          setState(() {
            _clientName = client.name;
            _selectedClientId = client.id;
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${AppStrings.clientFound}${client.name}'),
              backgroundColor: AppTheme.primaryColor,
            ),
          );
        } else {
          setState(() {
            _clientName = null;
            _selectedClientId = null;
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AppStrings.clientNotFound),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        setState(() {
          _clientName = null;
          _selectedClientId = null;
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppStrings.errorSearchingClient}$e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _confirmDelete() {
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(AppStrings.deleteConfirmation),
          content: Text(
            '${AppStrings.deleteClientFinalConfirmation}$_clientName${AppStrings.deleteClientFinalWarning}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(AppStrings.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performDelete();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text(AppStrings.yes),
            ),
          ],
        );
      },
    );
  }

  void _cancelDelete() {
    setState(() {
      _clientName = null;
      _selectedClientId = null;
      _clientIdController.clear();
      _searchController.clear();
      _showClientList = false;
    });
  }

  void _performDelete() {
    final clientId = _selectedClientId ?? _clientIdController.text.trim();

    if (clientId.isNotEmpty && _clientBloc != null) {
      
      _clientBloc!.add(DeleteClientEvent(clientId: clientId));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.pleaseSelectClientToDelete),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
