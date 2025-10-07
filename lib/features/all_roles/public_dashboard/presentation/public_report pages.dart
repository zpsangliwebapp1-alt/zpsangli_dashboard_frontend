import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class PublicReportsPage extends StatefulWidget {
  const PublicReportsPage({super.key});

  @override
  State<PublicReportsPage> createState() => _PublicReportsPageState();
}

class _PublicReportsPageState extends State<PublicReportsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> history = ["Daily Report - 20 Sep", "Weekly Report - Sep W2"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  /// Pick PDF / Excel
  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'xlsx'],
    );
    if (result != null) {
      setState(() {
        history.add(result.files.single.name); // Add to history
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Uploaded: ${result.files.single.name}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Tab Switch (Daily / Weekly)
        TabBar(
          controller: _tabController,
          labelColor: Colors.deepPurple,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: "Daily"),
            Tab(text: "Weekly"),
          ],
        ),

        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildReportContent("Daily Report Data"),
              _buildReportContent("Weekly Report Data"),
            ],
          ),
        ),

        /// Upload button
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: ElevatedButton.icon(
            onPressed: _pickFile,
            icon: const Icon(Icons.upload_file),
            label: const Text("Upload PDF / Excel"),
          ),
        ),

        /// History Section
        Expanded(
          child: Container(
            color: Colors.grey.shade100,
            padding: const EdgeInsets.all(12),
            child: ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.insert_drive_file, color: Colors.deepPurple),
                  title: Text(history[index]),
                  onTap: () {
                    // open report file / details
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReportContent(String text) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}
