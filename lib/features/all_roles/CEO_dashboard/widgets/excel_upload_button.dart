import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../auth/provider/auth_provider.dart';
import '../provider/upload_file_provider.dart';

class ExcelUploadButton extends StatelessWidget {
  const ExcelUploadButton({super.key});

  @override
  Widget build(BuildContext context) {
    final uploadProvider = context.watch<UploadFileProvider>();
    final authProvider = context.read<AuthProvider>(); // 👈 get token

    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            final result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['xlsx'],
              withData: true, // 👈 important for web
            );

            if (result != null && result.files.single.bytes != null) {
              final token = authProvider.token;
              if (token == null || token.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("❌ You are not logged in")),
                );
                return;
              }

              await uploadProvider.uploadFile(
                fileBytes: result.files.single.bytes!,
                fileName: result.files.single.name,
                departmentId: 4,
                bdoId: 1,
                month: 7,
                year: 2025,
                token: token, // 👈 use token from AuthProvider
              );
            }
          },
          icon: const Icon(Icons.upload_file),
          label: const Text("Upload Excel File"),
        ),
        if (uploadProvider.isLoading)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
        if (uploadProvider.uploadResponse != null)
          Text("✅ Uploaded: ${uploadProvider.uploadResponse!.originalFileName}"),
        if (uploadProvider.errorMessage != null)
          Text(
            "❌ Error: ${uploadProvider.errorMessage}",
            style: const TextStyle(color: Colors.red),
          ),
      ],
    );
  }
}
