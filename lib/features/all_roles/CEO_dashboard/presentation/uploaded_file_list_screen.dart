import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:zp_sangali_dashboard_flutter/features/all_roles/CEO_dashboard/presentation/uploaded_files_list.dart';

import '../../../auth/provider/auth_provider.dart';
import '../../../departments/model/departments_model.dart';
import '../../../departments/providers/department_provider.dart';
import '../../ceo_dashboard/controller/ceo_dashboard_controller.dart';
import '../provider/upload_file_provider.dart';
import '../provider/uploaded_file_list_provider.dart';
import '../models/uploaded_file_list_model.dart';
import 'excel_preview_screen.dart';

class UploadedFileListScreen extends StatefulWidget {
  const UploadedFileListScreen({super.key});

  @override
  State<UploadedFileListScreen> createState() => _UploadedFileListScreenState();
}

class _UploadedFileListScreenState extends State<UploadedFileListScreen> {
  @override
  void initState() {
    super.initState();
    // load departments on start
    context.read<DepartmentProvider>().loadDepartments();
  }

  @override
  Widget build(BuildContext context) {
    final deptProvider = context.watch<DepartmentProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Department File Management", style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: "How this works",
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('How to use'),
                  content: const Text(
                    'Select a department to view & manage uploaded Excel files. '
                        'Upload a file using the button, preview .xlsx files, and approve or reject files.',
                  ),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: deptProvider.loading
          ? const Center(child: CircularProgressIndicator())
          : deptProvider.departments.isEmpty
          ? const Center(child: Text("No departments found"))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildDepartmentGrid(
          context,
          deptProvider.departments,
              (dept) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DepartmentFilesScreen(department: dept),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Grid of gradient cards with Material icons (responsive)
  Widget _buildDepartmentGrid(
      BuildContext context,
      List<Department> departments,
      Function(Department) onTap,
      ) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 1200
        ? 4
        : width > 900
        ? 3
        : width > 600
        ? 2
        : 1;

    final gradients = [
      [Colors.pinkAccent, Colors.redAccent],
      [Colors.lightBlueAccent, Colors.blueAccent],
      [Colors.greenAccent, Colors.teal],
      [Colors.orangeAccent, Colors.deepOrange],
      [Colors.purpleAccent, Colors.indigo],
      [Colors.cyan, Colors.blueGrey],
    ];

    final icons = [
      Icons.account_balance,
      Icons.agriculture,
      Icons.school,
      Icons.local_hospital,
      Icons.construction,
      Icons.water_drop,
      Icons.people,
      Icons.map,
      Icons.energy_savings_leaf,
      Icons.home_repair_service,
    ];

    return GridView.builder(
      itemCount: departments.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 3.6,
      ),
      itemBuilder: (context, index) {
        final dept = departments[index];
        final colors = gradients[index % gradients.length];
        final icon = icons[index % icons.length];

        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => onTap(dept),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: colors.last.withOpacity(0.25),
                  blurRadius: 8,
                  offset: const Offset(2, 6),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.22),
                    radius: 26,
                    child: Icon(icon, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      dept.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


