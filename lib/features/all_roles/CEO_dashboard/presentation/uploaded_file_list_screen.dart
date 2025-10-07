import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../../auth/provider/auth_provider.dart';
import '../provider/uploaded_file_list_provider.dart';
import 'excel_preview_screen.dart';

class UploadedFileListScreen extends StatelessWidget {
  const UploadedFileListScreen({super.key});

  Future<void> _approveFile(String fileId, String token) async {
    final url = "https://rdprgovapi.atyoureye.com/api/files/$fileId/approve";

    final response = await http.post(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 204) {
      // Success
    } else {
      throw Exception("Failed to approve file");
    }
  }

  Future<void> _rejectFile(String fileId, String token) async {
    final url = "https://rdprgovapi.atyoureye.com/api/files/$fileId/unapprove";

    final response = await http.post(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 204) {
      // Success
    } else {
      throw Exception("Failed to reject file");
    }
  }

  @override
  Widget build(BuildContext context) {
    final uploadedFileProvider = context.watch<UploadedFileProvider>();
    final authProvider = context.read<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Uploaded Files")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              onPressed: () async {
                final token = authProvider.token;
                if (token == null) return;

                await uploadedFileProvider.fetchUploadedFiles(
                  departmentId: 4,
                  bdoId: 1,
                  month: 7,
                  year: 2025,
                  uploadedByUserId: 1,
                  token: token,
                );
              },
              child: const Text("Load Uploaded Files"),
            ),
          ),
          if (uploadedFileProvider.isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          if (uploadedFileProvider.errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                uploadedFileProvider.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: uploadedFileProvider.files.length,
              itemBuilder: (context, index) {
                final file = uploadedFileProvider.files[index];
                final extension = file.originalFileName
                    .split('.')
                    .last
                    .toLowerCase();

                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(file.originalFileName),
                    subtitle: Text(
                        "Size: ${file.sizeBytes} bytes | Uploaded: ${file.createdAt}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Preview Button
                        IconButton(
                          icon: const Icon(Icons.remove_red_eye),
                          onPressed: () {
                            final token = authProvider.token;
                            if (token == null) return;

                            if (extension == 'xlsx' || extension == 'xls') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ExcelPreviewScreen(
                                    storedFileName: file.storedFileName,
                                    token: token,
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "Preview not available for .$extension files"),
                                ),
                              );
                            }
                          },
                        ),

                        // Approve Button
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () async {
                            final token = authProvider.token;
                            if (token == null) return;
                            try {
                              await _approveFile(file.id.toString(), token);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("File Approved")));
                              await uploadedFileProvider.fetchUploadedFiles(
                                departmentId: 4,
                                bdoId: 1,
                                month: 7,
                                year: 2025,
                                uploadedByUserId: 1,
                                token: token,
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Error: $e")));
                            }
                          },
                        ),

                        // Reject Button
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () async {
                            final token = authProvider.token;
                            if (token == null) return;
                            try {
                              await _rejectFile(file.id.toString(), token);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("File Rejected")));
                              await uploadedFileProvider.fetchUploadedFiles(
                                departmentId: 4,
                                bdoId: 1,
                                month: 7,
                                year: 2025,
                                uploadedByUserId: 1,
                                token: token,
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Error: $e")));
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
