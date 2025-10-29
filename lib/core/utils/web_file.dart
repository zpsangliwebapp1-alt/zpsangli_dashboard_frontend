// import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';
//
// /// Web-specific file download
// String downloadFileWeb(Uint8List bytes, String fileName) {
//   final blob = html.Blob([bytes]);
//   final url = html.Url.createObjectUrlFromBlob(blob);
//   final anchor = html.AnchorElement(href: url)
//     ..download = fileName
//     ..style.display = 'none';
//   html.document.body!.append(anchor);
//   anchor.click();
//   anchor.remove();
//   html.Url.revokeObjectUrl(url);
//   return "Web download started";
// }