// features/all_roles/CEO_dashboard/presentation/excel_preview_screen.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:http/http.dart' as http;

class ExcelPreviewScreen extends StatefulWidget {
  final String storedFileName;
  final String token;

  const ExcelPreviewScreen({
    super.key,
    required this.storedFileName,
    required this.token,
  });

  @override
  State<ExcelPreviewScreen> createState() => _ExcelPreviewScreenState();
}

class _ExcelPreviewScreenState extends State<ExcelPreviewScreen> {
  List<List<dynamic>> _tableData = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _downloadAndParseExcel();
  }

  Future<void> _downloadAndParseExcel() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final url =
          "https://rdprgovapi.atyoureye.com/api/files/download/${widget.storedFileName}";
      final response = await http.get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer ${widget.token}"},
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to download file");
      }

      final Uint8List bytes = response.bodyBytes;
      final excel = Excel.decodeBytes(bytes);

      List<List<dynamic>> rows = [];
      for (var table in excel.tables.keys) {
        for (var row in excel.tables[table]!.rows) {
          rows.add(row.map((cell) => cell?.value ?? "").toList());
        }
      }

      setState(() {
        _tableData = rows;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return  Scaffold(
        appBar: AppBar(title: Text("Preview Excel")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Preview Excel")),
        body: Center(
          child: Text(
            "Error: $_error",
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    if (_tableData.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Preview Excel")),
        body: const Center(
          child: Text("No data found in this Excel file."),
        ),
      );
    }

    final headers = _tableData.first;
    final rows = _tableData.skip(1).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Preview: ${widget.storedFileName}"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
          child: PaginatedDataTable(
            header: Text(
              "Excel Preview",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            rowsPerPage: 10,
            columnSpacing: 20,
            horizontalMargin: 10,
            showCheckboxColumn: false,
            columns: headers
                .map(
                  (h) => DataColumn(
                label: Text(
                  h.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.indigo,
                  ),
                ),
              ),
            )
                .toList(),
            source: _ExcelDataSource(rows),
            headingRowHeight: 56,
            dataRowHeight: 48,
            dividerThickness: 1,
          ),
        ),
      ),
    );
  }
}

class _ExcelDataSource extends DataTableSource {
  final List<List<dynamic>> rows;
  _ExcelDataSource(this.rows);

  @override
  DataRow? getRow(int index) {
    if (index >= rows.length) return null;
    final row = rows[index];
    return DataRow.byIndex(
      index: index,
      cells: row
          .map(
            (cell) => DataCell(
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 200),
            child: Text(
              cell.toString(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      )
          .toList(),
    );
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => rows.length;
  @override
  int get selectedRowCount => 0;
}
