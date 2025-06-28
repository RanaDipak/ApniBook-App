import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/app_context_extensions.dart';


class ClientListPage extends StatelessWidget {
  const ClientListPage({super.key});

  static const List<Map<String, String>> _clients = [
    {'name': 'a', 'mobile': '2222222222'},
    {'name': 'brijesh', 'mobile': '1231231231'},
    {'name': 'pqr', 'mobile': '2222222222'},
    {'name': 'mitesh', 'mobile': '7359526453'},
    {'name': 'jay', 'mobile': '8780846464'},
    {'name': 'kruti', 'mobile': '8849817263'},
    {'name': 'suhan', 'mobile': '8888888822'},
    {'name': 'dummy', 'mobile': '8888888883'},
    {'name': 'xyZ', 'mobile': 'oooooooooo'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(80),
            bottomRight: Radius.circular(80),
          ),
          child: AppBar(
            backgroundColor: context.primaryColor,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              AppStrings.clientBook,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        itemCount: _clients.length,
        itemBuilder: (context, index) {
          final client = _clients[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(context.cardRadius),
              side: BorderSide(color: context.primaryColor),
            ),
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 24,
                child:
                    Icon(Icons.person, size: 32, color: context.primaryColor),
              ),
              title: Text(
                client['name'] ?? '',
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
              subtitle: Text(
                client['mobile'] ?? '',
                style: const TextStyle(fontSize: 15),
              ),
              
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: context.primaryColor,
        onPressed: () {
          
        },
        tooltip: 'Add Client',
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }
}
