import 'dart:typed_data';

String downloadFileWeb(Uint8List bytes, String fileName) {
  // ❌ No-op for mobile/desktop
  throw UnsupportedError('Web download is not supported on this platform.');
}
