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
import '../controller/ceo_dashboard_controller.dart';
import '../models/uploaded_file_list_model.dart';
import '../provider/bdo_list_provider.dart';
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
  int? _selectedBdoId;

  Future<void> _approveFile(String fileId, String token) async {
    final url = "https://rdprgovapi.atyoureye.com/api/files/$fileId/approve";
    final response =
    await http.post(Uri.parse(url), headers: {"Authorization": "Bearer $token"});
    if (response.statusCode != 204) {
      throw Exception("Failed to approve file (status: ${response.statusCode})");
    }
  }

  Future<void> _rejectFile(String fileId, String token) async {
    final url = "https://rdprgovapi.atyoureye.com/api/files/$fileId/unapprove";
    final response =
    await http.post(Uri.parse(url), headers: {"Authorization": "Bearer $token"});
    if (response.statusCode != 204) {
      throw Exception("Failed to reject file (status: ${response.statusCode})");
    }
  }

  @override
  void initState() {
    super.initState();

    // ✅ Fetch BDO list when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final bdoProvider = context.read<BdoListProvider>();
      await bdoProvider.fetchBdos();

      // ✅ Auto-select the first BDO
      if (bdoProvider.bdoList.isNotEmpty) {
        setState(() {
          _selectedBdoId = bdoProvider.bdoList.first['id'];
        });
      }

      // ✅ Then load uploaded files using selected BDO
      _refreshFiles();
    });
  }

  Future<void> _refreshFiles() async {
    final now = DateTime.now();
    final auth = context.read<AuthProvider>();
    final token = auth.token;
    final uploadedBy = auth.userId ?? 0;

    if (token != null && token.isNotEmpty && _selectedBdoId != null) {
      await context.read<UploadedFileProvider>().fetchUploadedFiles(
        departmentId: widget.department.id,
        bdoId: _selectedBdoId!,
        month: now.month,
        year: now.year,
        uploadedByUserId: uploadedBy,
        token: token,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final uploadProvider = context.watch<UploadFileProvider>();
    final uploadedFileProvider = context.watch<UploadedFileProvider>();
    final authProvider = context.read<AuthProvider>();
    final bdoProvider = context.watch<BdoListProvider>();
    final now = DateTime.now();
    final currentMonth = DateFormat('MMMM yyyy').format(now);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.department.name),
        backgroundColor: Colors.blue.shade800,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshFiles)
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
              // ✅ BDO Dropdown selector
              if (bdoProvider.isLoading)
                const Center(child: CircularProgressIndicator())
              else
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: 'Select BDO',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedBdoId,
                  items: bdoProvider.bdoList
                      .map((bdo) => DropdownMenuItem<int>(
                    value: bdo['id'],
                    child: Text(bdo['name']),
                  ))
                      .toList(),
                  onChanged: (val) {
                    setState(() => _selectedBdoId = val);
                    _refreshFiles();
                  },
                ),

              const SizedBox(height: 20),

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

              // File header
              Text(
                "Uploaded Files ($currentMonth)",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 12),

              // Uploaded Files List
              uploadedFileProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : uploadedFileProvider.files.isEmpty
                  ? const Center(child: Padding(
                padding: EdgeInsets.all(24),
                child: Text("No files uploaded yet"),
              ))
                  : Column(
                children: uploadedFileProvider.files.map((file) {
                  final ext = file.originalFileName.split('.').last.toLowerCase();
                  return _buildUploadedFileTile(
                      file, ext, authProvider, uploadedFileProvider);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadedFileTile(
      UploadedFile file,
      String extension,
      AuthProvider authProvider,
      UploadedFileProvider uploadedFileProvider) {
    final token = authProvider.token;
    final formattedDate = file.createdAt != null
        ? DateFormat('dd MMM yyyy, hh:mm a').format(file.createdAt!)
        : 'Unknown';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: _fileLeadingIcon(extension),
        title: Text(file.originalFileName,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text("Size: ${file.sizeBytes} bytes • Uploaded: $formattedDate"),
        trailing: Wrap(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_red_eye),
              onPressed: () {
                if (token != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ExcelPreviewScreen(token: token, id: file.id),
                    ),
                  );
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: () async {
                if (token == null) return;
                await _approveFile(file.id.toString(), token);
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text("File Approved")));
                await _refreshFiles();
              },
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () async {
                if (token == null) return;
                await _rejectFile(file.id.toString(), token);
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text("File Rejected")));
                await _refreshFiles();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _fileLeadingIcon(String ext) {
    IconData icon;
    Color color;
    switch (ext) {
      case 'xlsx':
      case 'xls':
        icon = Icons.table_chart;
        color = Colors.green;
        break;
      case 'pdf':
        icon = Icons.picture_as_pdf;
        color = Colors.red;
        break;
      default:
        icon = Icons.insert_drive_file;
        color = Colors.grey;
    }
    return CircleAvatar(backgroundColor: color, child: Icon(icon, color: Colors.white));
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
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(children: [
              const Icon(Icons.upload_file, color: Colors.blue),
              const SizedBox(width: 8),
              Expanded(
                  child: Text("Upload Excel for $deptName",
                      style: const TextStyle(fontWeight: FontWeight.bold))),
            ]),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.cloud_upload),
              label: const Text("Select & Upload Excel"),
              onPressed: () async {
                if (_selectedBdoId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select a BDO first")));
                  return;
                }

                final result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['xlsx'],
                  withData: true,
                );

                if (result != null && result.files.single.bytes != null) {
                  final token = authProvider.token;
                  if (token == null || token.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("You are not logged in")));
                    return;
                  }

                  await uploadProvider.uploadFile(
                    fileBytes: result.files.single.bytes!,
                    fileName: result.files.single.name,
                    departmentId: deptId,
                    bdoId: _selectedBdoId!,
                    month: now.month,
                    year: now.year,
                    token: token,
                  );

                  if (uploadProvider.uploadResponse != null) {
                    await _refreshFiles();
                  }
                }
              },
            ),
            if (uploadProvider.isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: LinearProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
