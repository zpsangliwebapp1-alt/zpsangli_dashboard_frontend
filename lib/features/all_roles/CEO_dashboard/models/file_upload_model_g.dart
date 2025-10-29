// import 'package:flutter/foundation.dart';
//
// @immutable
// class FileUploadModel {
//   final int id;
//   final String originalFileName;
//   final String storedFileName;
//   final int sizeBytes;
//   final int departmentId;
//   final int bdoId;
//   final int importedRows;
//   final int skippedRows;
//   final int month;
//   final int year;
//   final bool isApproved;
//   final DateTime createdAt;
//
//   const FileUploadModel({
//     required this.id,
//     required this.originalFileName,
//     required this.storedFileName,
//     required this.sizeBytes,
//     required this.departmentId,
//     required this.bdoId,
//     required this.importedRows,
//     required this.skippedRows,
//     required this.month,
//     required this.year,
//     required this.isApproved,
//     required this.createdAt,
//   });
//
//   /// ✅ Factory constructor for parsing JSON
//   factory FileUploadModel.fromJson(Map<String, dynamic> json) {
//     return FileUploadModel(
//       id: json['id'] ?? 0,
//       originalFileName: json['originalFileName'] ?? '',
//       storedFileName: json['storedFileName'] ?? '',
//       sizeBytes: json['sizeBytes'] ?? 0,
//       departmentId: json['departmentId'] ?? 0,
//       bdoId: json['bdoId'] ?? 0,
//       importedRows: json['importedRows'] ?? 0,
//       skippedRows: json['skippedRows'] ?? 0,
//       month: json['month'] ?? 0,
//       year: json['year'] ?? 0,
//       isApproved: json['isApproved'] ?? false,
//       createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
//     );
//   }
//
//   /// ✅ Convert model back to JSON (for future APIs)
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'originalFileName': originalFileName,
//       'storedFileName': storedFileName,
//       'sizeBytes': sizeBytes,
//       'departmentId': departmentId,
//       'bdoId': bdoId,
//       'importedRows': importedRows,
//       'skippedRows': skippedRows,
//       'month': month,
//       'year': year,
//       'isApproved': isApproved,
//       'createdAt': createdAt.toIso8601String(),
//     };
//   }
//
//   /// ✅ Handy copyWith for immutable state updates
//   FileUploadModel copyWith({
//     int? id,
//     String? originalFileName,
//     String? storedFileName,
//     int? sizeBytes,
//     int? departmentId,
//     int? bdoId,
//     int? importedRows,
//     int? skippedRows,
//     int? month,
//     int? year,
//     bool? isApproved,
//     DateTime? createdAt,
//   }) {
//     return FileUploadModel(
//       id: id ?? this.id,
//       originalFileName: originalFileName ?? this.originalFileName,
//       storedFileName: storedFileName ?? this.storedFileName,
//       sizeBytes: sizeBytes ?? this.sizeBytes,
//       departmentId: departmentId ?? this.departmentId,
//       bdoId: bdoId ?? this.bdoId,
//       importedRows: importedRows ?? this.importedRows,
//       skippedRows: skippedRows ?? this.skippedRows,
//       month: month ?? this.month,
//       year: year ?? this.year,
//       isApproved: isApproved ?? this.isApproved,
//       createdAt: createdAt ?? this.createdAt,
//     );
//   }
// }
