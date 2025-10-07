import 'package:flutter/material.dart';
import '../json_api_service/json_api_service.dart';
import '../models/json_data_model.dart';
import '../widgets/department_overview_card.dart';


class DepartmentDashboard extends StatefulWidget {
  final String block;
  final String department;

  const DepartmentDashboard({
    super.key,
    required this.block,
    required this.department,
  });

  @override
  State<DepartmentDashboard> createState() => _DepartmentDashboardState();
}

class _DepartmentDashboardState extends State<DepartmentDashboard> {
  JsonDataResponse? apiResponse;
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final result = await JsonApiService.fetchDepartmentData(
        month: 7,
        year: 2025,
        departmentId: 4,
        bdoId: 1,
        uploadedByUserId: 1,
      );
      setState(() {
        apiResponse = result;
      });
    } catch (e) {
      setState(() {
        error = "Failed to load data: $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Department Dashboard - ${widget.department}"),
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(child: Text(error!))
          : apiResponse == null
          ? const Center(child: Text("No Data"))
          : DepartmentOverviewCard(
        block: widget.block,
        department: widget.department,
        lastUpdated: DateTime.now(),
        apiResponse: apiResponse!,
        onRefresh: _loadData,
      ),
    );
  }
}
