import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/app_context_extensions.dart';
import '../../domain/entities/client.dart';
import '../bloc/client_bloc.dart';
import 'add_edit_client_page.dart';
import 'client_details_page.dart';

class ClientListPage extends StatelessWidget {
  const ClientListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ClientBloc(
            addClient: serviceLocator.addClient,
            updateClient: serviceLocator.updateClient,
            deleteClient: serviceLocator.deleteClient,
            getClients: serviceLocator.getClients,
            searchClients: serviceLocator.searchClients,
          )..add(
            LoadClientsEvent(),
          ), // Load clients immediately when bloc is created
      child: const _ClientListContent(),
    );
  }
}

class _ClientListContent extends StatefulWidget {
  const _ClientListContent();

  @override
  State<_ClientListContent> createState() => _ClientListContentState();
}

class _ClientListContentState extends State<_ClientListContent> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
              // Header with search bar
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
                    Center(
                      child: Text(
                        AppStrings.clientBook,
                        style: AppTheme.headline.copyWith(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                     // Search bar
                    // Padding(
                    //   padding: EdgeInsets.symmetric(
                    //     horizontal: context.pagePadding,
                    //   ),
                    //   child: TextField(
                    //     controller: _searchController,
                    //     style: const TextStyle(color: Colors.white),
                    //     decoration: InputDecoration(
                    //       hintText: AppStrings.searchClients,
                    //       hintStyle: const TextStyle(color: Colors.white70),
                    //       prefixIcon: const Icon(
                    //         Icons.search,
                    //         color: Colors.white70,
                    //       ),
                    //       suffixIcon: _searchController.text.isNotEmpty
                    //           ? IconButton(
                    //               icon: const Icon(
                    //                 Icons.clear,
                    //                 color: Colors.white70,
                    //               ),
                    //               onPressed: () {
                    //                 _searchController.clear();
                    //                 context.read<ClientBloc>().add(
                    //                   LoadClientsEvent(),
                    //                 );
                    //               },
                    //             )
                    //           : null,
                    //       border: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(
                    //           context.cardRadius,
                    //         ),
                    //         borderSide: const BorderSide(color: Colors.white),
                    //       ),
                    //       enabledBorder: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(
                    //           context.cardRadius,
                    //         ),
                    //         borderSide: const BorderSide(color: Colors.white),
                    //       ),
                    //       focusedBorder: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(
                    //           context.cardRadius,
                    //         ),
                    //         borderSide: const BorderSide(
                    //           color: Colors.white,
                    //           width: 2,
                    //         ),
                    //       ),
                    //     ),
                    //     onChanged: (value) {
                    //       if (value.trim().isEmpty) {
                    //         context.read<ClientBloc>().add(LoadClientsEvent());
                    //       } else {
                    //         context.read<ClientBloc>().add(
                    //           SearchClientsEvent(query: value),
                    //         );
                    //       }
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              ),

              // Client list
              Expanded(child: _buildClientList(state)),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppTheme.primaryColor,
            onPressed: () => _navigateToAddClient(context),
            tooltip: AppStrings.addClient,
            child: Icon(
              Icons.add,
              size: context.iconSize * 2,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  Widget _buildClientList(ClientState state) {
    if (state is ClientLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is ClientsLoaded) {
      final clients = state.clients;

      if (clients.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                AppStrings.noClientsFound,
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.addFirstClientMessage,
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.symmetric(
          vertical: 16,
          horizontal: context.pagePadding,
        ),
        itemCount: clients.length,
        itemBuilder: (context, index) {
          final client = clients[index];

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(context.cardRadius),
              side: const BorderSide(color: AppTheme.primaryColor),
            ),
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                radius: context.iconSize,
                child: Icon(
                  Icons.person,
                  size: context.iconSize * 2,
                  color: AppTheme.primaryColor,
                ),
              ),
              title: Text(
                client.name,
                style: AppTheme.body.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    client.mobileNumber,
                    style: AppTheme.caption.copyWith(color: AppTheme.textColor),
                  ),
                  Text(
                    client.businessType,
                    style: AppTheme.caption.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: AppTheme.primaryColor,
                      size: context.iconSize,
                    ),
                    onPressed: () => _navigateToEditClient(context, client),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: context.iconSize,
                    ),
                    onPressed: () => _showDeleteConfirmation(context, client),
                  ),
                ],
              ),
              onTap: () => _navigateToClientDetails(context, client),
            ),
          );
        },
      );
    } else if (state is ClientError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              AppStrings.errorLoadingClients,
              style: TextStyle(fontSize: 18, color: Colors.red[600]),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                context.read<ClientBloc>().add(LoadClientsEvent());
              },
              child: const Text(AppStrings.retry),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  void _navigateToAddClient(BuildContext context) async {
    final result = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const AddEditClientPage()));

    if (result == true) {
      // Refresh the client list
      context.read<ClientBloc>().add(LoadClientsEvent());
    }
  }

  void _navigateToEditClient(BuildContext context, Client client) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEditClientPage(client: client),
      ),
    );

    if (result == true) {
      // Refresh the client list
      context.read<ClientBloc>().add(LoadClientsEvent());
    }
  }

  void _navigateToClientDetails(BuildContext context, Client client) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => serviceLocator.createTransactionBloc(),
          child: ClientDetailsPage(client: client),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Client client) {
    // Store the bloc reference before showing the dialog
    final clientBloc = context.read<ClientBloc>();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(AppStrings.deleteClient),
          content: Text(
            '${AppStrings.deleteClientConfirmation}${client.name}${AppStrings.deleteClientWarning}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(AppStrings.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                // Use the stored bloc reference instead of context.read
                clientBloc.add(DeleteClientEvent(clientId: client.id));
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text(AppStrings.delete),
            ),
          ],
        );
      },
    );
  }
}
