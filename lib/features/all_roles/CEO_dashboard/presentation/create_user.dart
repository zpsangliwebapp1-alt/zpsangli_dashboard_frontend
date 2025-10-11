import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../auth/provider/auth_provider.dart';
import '../../../blocks/provider/block_provider.dart';
import '../provider/create_bdo_provider.dart';


class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bdoProvider = context.watch<CreateBdoProvider>();
    final authProvider = context.read<AuthProvider>();
    final token = authProvider.token ?? '';

    return Scaffold(
      body: Center(
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(24),
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "BDO तयार करा",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "BDO Name",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: bdoProvider.loading
                        ? null
                        : () async {
                      await bdoProvider.createBdo(_nameController.text.trim(), token);
                      if (bdoProvider.error != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(bdoProvider.error!)),
                        );
                      } else if (bdoProvider.createdBdo != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("BDO created successfully!")),
                        );
                        _nameController.clear();
                      }
                    },
                    child: bdoProvider.loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Create BDO"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
