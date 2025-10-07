import 'dart:convert';

class UploadFileResponse {
  final int id;
  final String originalFileName;
  final int sizeBytes;
  final int departmentId;
  final int bdoId;
  final int importedRows;
  final int skippedRows;
  final int month;
  final int year;
  final String jsonData;

  UploadFileResponse({
    required this.id,
    required this.originalFileName,
    required this.sizeBytes,
    required this.departmentId,
    required this.bdoId,
    required this.importedRows,
    required this.skippedRows,
    required this.month,
    required this.year,
    required this.jsonData,
  });

  factory UploadFileResponse.fromJson(Map<String, dynamic> json) {
    return UploadFileResponse(
      id: json['id'],
      originalFileName: json['originalFileName'],
      sizeBytes: json['sizeBytes'],
      departmentId: json['departmentId'],
      bdoId: json['bdoId'],
      importedRows: json['importedRows'],
      skippedRows: json['skippedRows'],
      month: json['month'],
      year: json['year'],
      jsonData: json['jsonData'],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "originalFileName": originalFileName,
    "sizeBytes": sizeBytes,
    "departmentId": departmentId,
    "bdoId": bdoId,
    "importedRows": importedRows,
    "skippedRows": skippedRows,
    "month": month,
    "year": year,
    "jsonData": jsonData,
  };

  Map<String, dynamic> get parsedJsonData => json.decode(jsonData);
}
