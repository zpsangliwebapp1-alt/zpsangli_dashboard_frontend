// models/uploaded_file_model.dart
class UploadedFile {
  final int id;
  final String originalFileName;
  final String storedFileName;
  final int sizeBytes;
  final int departmentId;
  final int bdoId;
  final int importedRows;
  final int skippedRows;
  final int month;
  final int year;
  final bool isApproved;
  final DateTime createdAt;

  UploadedFile({
    required this.id,
    required this.originalFileName,
    required this.storedFileName,
    required this.sizeBytes,
    required this.departmentId,
    required this.bdoId,
    required this.importedRows,
    required this.skippedRows,
    required this.month,
    required this.year,
    required this.isApproved,
    required this.createdAt,
  });

  factory UploadedFile.fromJson(Map<String, dynamic> json) => UploadedFile(
    id: json['id'],
    originalFileName: json['originalFileName'],
    storedFileName: json['storedFileName'],
    sizeBytes: json['sizeBytes'],
    departmentId: json['departmentId'],
    bdoId: json['bdoId'],
    importedRows: json['importedRows'],
    skippedRows: json['skippedRows'],
    month: json['month'],
    year: json['year'],
    isApproved: json['isApproved'],
    createdAt: DateTime.parse(json['createdAt']),
  );
}
