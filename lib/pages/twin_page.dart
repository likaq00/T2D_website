import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TwinPage extends StatelessWidget {
  const TwinPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Digital Twin'),
        actions: [
          if (user?.email != null)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(child: Text(user!.email!)),
            ),
          IconButton(
            tooltip: 'Logout',
            onPressed: () async { await Supabase.instance.client.auth.signOut(); },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const Center(child: Text('Models/predictions will go here.')),
    );
  }
}
