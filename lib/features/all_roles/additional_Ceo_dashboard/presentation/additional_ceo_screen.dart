import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/additional_ceo_list_provider.dart';

class AdditionalCeoListScreen extends StatefulWidget {
  const AdditionalCeoListScreen({super.key});

  @override
  State<AdditionalCeoListScreen> createState() => _AdditionalCeoListScreenState();
}

class _AdditionalCeoListScreenState extends State<AdditionalCeoListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<AdditionalCeoListProvider>().fetchAdditionalCeoList());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AdditionalCeoListProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Additional CEOs')),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.error != null
          ? Center(child: Text('Error: ${provider.error}'))
          : ListView.builder(
        itemCount: provider.ceoList.length,
        itemBuilder: (context, index) {
          final ceo = provider.ceoList[index];
          return ListTile(
            title: Text(ceo.username),
            subtitle: Text(ceo.roleName),
            trailing: ceo.isActive
                ? const Icon(Icons.check_circle, color: Colors.green)
                : const Icon(Icons.cancel, color: Colors.red),
          );
        },
      ),
    );
  }
}
