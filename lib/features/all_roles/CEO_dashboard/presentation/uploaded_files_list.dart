/* -------------------------------------------------------------------------- */
/* --------------------------- Department Files Screen ---------------------- */
/* -------------------------------------------------------------------------- */
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

import '../../../auth/provider/auth_provider.dart';
import '../../../departments/model/departments_model.dart';
import '../../../departments/providers/department_provider.dart';
import '../controller/ceo_dashboard_controller.dart';
import '../models/uploaded_file_list_model.dart';
import '../provider/upload_file_provider.dart';
import '../provider/uploaded_file_list_provider.dart';
import 'excel_preview_screen.dart';
class DepartmentFilesScreen extends StatefulWidget {
  final Department department;
  const DepartmentFilesScreen({super.key, required this.department});

  @override
  State<DepartmentFilesScreen> createState() => _DepartmentFilesScreenState();
}

class _DepartmentFilesScreenState extends State<DepartmentFilesScreen> {
  late final CeoDashboardController ceoController = context.read<CeoDashboardController>();
  late final CeoDashboardController controller = context.read<CeoDashboardController>();
  late final String bdoId = controller.selectedBlock ?? "1";

  Future<void> _approveFile(String fileId, String token) async {
    final url = "https://rdprgovapi.atyoureye.com/api/files/$fileId/approve";
    final response = await http.post(Uri.parse(url), headers: {"Authorization": "Bearer $token"});
    if (response.statusCode != 204) {
      throw Exception("Failed to approve file (status: ${response.statusCode})");
    }
  }

  Future<void> _rejectFile(String fileId, String token) async {
    final url = "https://rdprgovapi.atyoureye.com/api/files/$fileId/unapprove";
    final response = await http.post(Uri.parse(url), headers: {"Authorization": "Bearer $token"});
    if (response.statusCode != 204) {
      throw Exception("Failed to reject file (status: ${response.statusCode})");
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final now = DateTime.now();
      final token = context.read<AuthProvider>().token;
      if (token != null) {
        context.read<UploadedFileProvider>().fetchUploadedFiles(
          departmentId: widget.department.id,
          bdoId: 1,
          month: now.month,
          year: now.year,
          uploadedByUserId: 2,
          token: token,
        );
      }
    });
  }

  Future<void> _refreshFiles() async {
    final now = DateTime.now();
    final auth = context.read<AuthProvider>();
    final ctrl = context.read<CeoDashboardController>();

    final token = auth.token;
    final bdoId = int.tryParse(ctrl.selectedBlock ?? '0') ?? 0;
    final uploadedBy = auth.userId ?? 0;

    debugPrint('🔄 Refreshing Files for Dept: ${widget.department.id}, BDO: $bdoId, User: $uploadedBy');

    if (token != null && token.isNotEmpty) {
      await context.read<UploadedFileProvider>().fetchUploadedFiles(
        departmentId: widget.department.id,
        bdoId: bdoId,
        month: now.month,
        year: now.year,
        uploadedByUserId: uploadedBy,
        token: token,
      );
    } else {
      debugPrint('⚠️ Missing Token!');
    }
  }


  @override
  Widget build(BuildContext context) {
    final uploadProvider = context.watch<UploadFileProvider>();
    final uploadedFileProvider = context.watch<UploadedFileProvider>();
    final authProvider = context.read<AuthProvider>();
    final now = DateTime.now();
    final currentMonth = DateFormat('MMMM yyyy').format(now);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.department.name),
        backgroundColor: Colors.blue.shade800,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshFiles,
            tooltip: 'Refresh list',
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshFiles,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Upload Card
              _buildUploadCard(
                context,
                uploadProvider,
                authProvider,
                widget.department.id,
                widget.department.name,
                now,
                uploadedFileProvider,
              ),
              const SizedBox(height: 20),

              // Header for uploaded files
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Uploaded Files ($currentMonth)",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  // simple search/filter placeholder
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.filter_list),
                        onPressed: () {
                          // You can implement filter modal here
                          showModalBottomSheet(
                            context: context,
                            builder: (_) => _buildFilterSheet(uploadedFileProvider),
                          );
                        },
                        tooltip: 'Filter',
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 12),

              // File list
              uploadedFileProvider.isLoading
                  ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CircularProgressIndicator()),
              )
                  : uploadedFileProvider.files.isEmpty
                  ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text("No files uploaded yet"),
                ),
              )
                  : Column(
                children: uploadedFileProvider.files.map((file) {
                  final extension = file.originalFileName.split('.').last.toLowerCase();
                  return _buildUploadedFileTile(
                    file,
                    extension,
                    authProvider,
                    uploadedFileProvider,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSheet(UploadedFileProvider uploadedFileProvider) {
    // placeholder for filter controls - can be expanded
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Filters', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.hourglass_top),
            title: const Text('Pending approval'),
            onTap: () {
              // implement filter action if provider supports
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.check_circle_outline),
            title: const Text('Approved'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }

  Widget _buildUploadedFileTile(
      UploadedFile file,
      String extension,
      AuthProvider authProvider,
      UploadedFileProvider uploadedFileProvider,
      ) {
    final token = authProvider.token;
    final uploadedAt = file.createdAt;
    final formattedDate = uploadedAt != null ? DateFormat('dd MMM yyyy, hh:mm a').format(uploadedAt) : 'Unknown';

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: _fileLeadingIcon(extension),
        title: Text(
          file.originalFileName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text("Size: ${file.sizeBytes} bytes • Uploaded: $formattedDate"),
        trailing: Wrap(
          spacing: 8,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_red_eye),
              tooltip: 'Preview',
              onPressed: () {
                if (token == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("You are not logged in")));
                  return;
                }
                if (extension == 'xlsx' || extension == 'xls') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ExcelPreviewScreen(token: token, id: file.id),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Preview not available for .$extension files")),
                  );
                }
              },
            ),

            // Approve
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              tooltip: 'Approve',
              onPressed: () async {
                if (token == null) return;
                final confirmed = await _confirmDialog(context, 'Approve file', 'Are you sure you want to approve this file?');
                if (!confirmed) return;
                try {
                  await _approveFile(file.id.toString(), token);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("File Approved")));
                  await _refreshFiles();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Approve failed: $e')));
                }
              },
            ),

            // Reject
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              tooltip: 'Reject',
              onPressed: () async {
                if (token == null) return;
                final confirmed = await _confirmDialog(context, 'Reject file', 'Are you sure you want to reject this file?');
                if (!confirmed) return;
                try {
                  await _rejectFile(file.id.toString(), token);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("File Rejected")));
                  await _refreshFiles();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Reject failed: $e')));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _fileLeadingIcon(String extension) {
    // neat icon + color badge for common extensions
    IconData icon;
    Color bg;
    switch (extension) {
      case 'xlsx':
      case 'xls':
        icon = Icons.table_chart;
        bg = Colors.green.shade600;
        break;
      case 'pdf':
        icon = Icons.picture_as_pdf;
        bg = Colors.red.shade600;
        break;
      case 'doc':
      case 'docx':
        icon = Icons.description;
        bg = Colors.blue.shade700;
        break;
      default:
        icon = Icons.insert_drive_file;
        bg = Colors.grey.shade600;
    }

    return CircleAvatar(
      radius: 22,
      backgroundColor: bg,
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _buildUploadCard(
      BuildContext context,
      UploadFileProvider uploadProvider,
      AuthProvider authProvider,
      int deptId,
      String deptName,
      DateTime now,
      UploadedFileProvider uploadedFileProvider,
      ) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Title
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.upload_file, color: Colors.blue, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Upload Excel for $deptName",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
                // month label
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    DateFormat('MMMM yyyy').format(now),
                    style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Instructions
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    "Select an .xlsx file to upload. Files will be visible below for preview and approval.",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Buttons row
            Row(
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                  ),
                  icon: const Icon(Icons.cloud_upload, color: Colors.white),
                  label: const Text("Select & Upload Excel", style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['xlsx'],
                      withData: true,
                    );

                    if (result != null && result.files.single.bytes != null) {
                      final token = authProvider.token;
                      if (token == null || token.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("You are not logged in")),
                        );
                        return;
                      }

                      await uploadProvider.uploadFile(
                        fileBytes: result.files.single.bytes!,
                        fileName: result.files.single.name,
                        departmentId: widget.department.id,
                        bdoId: 103,
                        month: now.month,
                        year: now.year,
                        token: token,
                      );

                      if (uploadProvider.uploadResponse != null) {
                        // refresh the uploaded files list after success
                        await uploadedFileProvider.fetchUploadedFiles(
                          departmentId:widget.department.id,
                          bdoId: 103,
                          month: now.month,
                          year: now.year,
                          uploadedByUserId: 15,
                          token: token,
                        );
                      }
                    }
                  },
                ),

                const SizedBox(width: 12),

                // optional clear / sample file button
                OutlinedButton.icon(
                  icon: const Icon(Icons.info_outline),
                  label: const Text("Sample"),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Sample Excel Format"),
                        content: const Text("Place here a brief description of the required column structure."),
                        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close"))],
                      ),
                    );
                  },
                ),
              ],
            ),

            // Upload feedback area
            const SizedBox(height: 12),
            if (uploadProvider.isLoading)
              const LinearProgressIndicator(),

            if (uploadProvider.uploadResponse != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text("Uploaded: ${uploadProvider.uploadResponse!.originalFileName}",
                          style: const TextStyle(color: Colors.green)),
                    )
                  ],
                ),
              ),

            if (uploadProvider.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(child: Text("Error: ${uploadProvider.errorMessage}", style: const TextStyle(color: Colors.red))),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<bool> _confirmDialog(BuildContext context, String title, String content) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Yes')),
        ],
      ),
    );

    return result ?? false;
  }
}