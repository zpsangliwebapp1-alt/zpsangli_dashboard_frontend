import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ExcelPreviewScreen extends StatefulWidget {
  final dynamic id; // can be String or int
  final String token;

  const ExcelPreviewScreen({
    super.key,
    required this.id,
    required this.token,
  });

  @override
  State<ExcelPreviewScreen> createState() => _ExcelPreviewScreenState();
}

class _ExcelPreviewScreenState extends State<ExcelPreviewScreen> {
  bool _loading = true;
  String? _error;
  List<List<dynamic>> _tableData = [];

  @override
  void initState() {
    super.initState();
    _loadExcel();
  }

  Future<void> _loadExcel() async {
    try {
      final dio = Dio();
      final url =
          "https://rdprgovapi.atyoureye.com/api/files/${widget.id}/download";

      final response = await dio.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer ${widget.token}",
            "Accept": "*/*",
          },
          responseType: ResponseType.bytes,
        ),
      );

      final bytes = Uint8List.fromList(response.data);
      final excel = Excel.decodeBytes(bytes);

      final firstSheet = excel.tables.keys.first;
      final table = excel.tables[firstSheet];

      setState(() {
        _tableData = table?.rows ?? [];
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = "Failed to load Excel: $e";
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Excel Preview")),
        body: Center(
          child: Text(_error!, style: const TextStyle(color: Colors.red)),
        ),
      );
    }

    if (_tableData.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("No data found in Excel file.")),
      );
    }

    final dataSource = ExcelDataSource(_tableData);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Excel Preview"),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadExcel),
        ],
      ),
      body: SfDataGrid(
        source: dataSource,
        frozenColumnsCount: 1,
        allowSorting: true,
        allowFiltering: true,
        gridLinesVisibility: GridLinesVisibility.both,
        headerGridLinesVisibility: GridLinesVisibility.both,
        columnWidthMode: ColumnWidthMode.auto,
        columns: _tableData.first.map((header) {
          final title = header?.toString() ?? '';
          return GridColumn(
            columnName: title,
            label: Container(
              alignment: Alignment.centerLeft,
              color: Colors.grey.shade200,
              padding: const EdgeInsets.all(8),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class ExcelDataSource extends DataGridSource {
  final List<List<dynamic>> tableData;
  late List<DataGridRow> _rows;

  ExcelDataSource(this.tableData) {
    final headers = tableData.first.map((e) => e?.toString() ?? '').toList();

    _rows = tableData.skip(1).map((row) {
      final cells = <DataGridCell>[];
      for (int i = 0; i < headers.length; i++) {
        cells.add(DataGridCell<String>(
          columnName: headers[i],
          value: i < row.length ? row[i]?.toString() ?? '' : '',
        ));
      }
      return DataGridRow(cells: cells);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map((cell) {
        return Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(cell.value.toString()),
        );
      }).toList(),
    );
  }
}
