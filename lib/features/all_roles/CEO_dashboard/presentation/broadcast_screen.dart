import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../auth/provider/auth_provider.dart';
import '../provider/broadcast_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class BroadcastScreen extends StatefulWidget {
  const BroadcastScreen({super.key});

  @override
  State<BroadcastScreen> createState() => _BroadcastScreenState();
}

class _BroadcastScreenState extends State<BroadcastScreen> {
  Uint8List? _selectedImageBytes;
  String? _selectedImageName;
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  DateTime? _selectedDate;
  bool _isLink = false;

  /// Pick Image (supports web + mobile)
  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true, // required for web
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _selectedImageBytes = result.files.single.bytes;
        _selectedImageName = result.files.single.name;
      });
    }
  }

  /// Pick Expiry Date
  Future<void> _pickDate() async {
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final broadcastProvider = context.watch<BroadcastProvider>();
    final authProvider = context.read<AuthProvider>();
    final token = authProvider.token ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text("Send Broadcast")),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Send Broadcast",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Toggle: Image / Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChoiceChip(
                        label: const Text("Image"),
                        selected: !_isLink,
                        onSelected: (v) => setState(() => _isLink = !v),
                      ),
                      const SizedBox(width: 10),
                      ChoiceChip(
                        label: const Text("Link"),
                        selected: _isLink,
                        onSelected: (v) => setState(() => _isLink = v),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Conditional Input
                  _isLink
                      ? TextField(
                    controller: _linkController,
                    decoration: InputDecoration(
                      labelText: "Enter URL",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  )
                      : InkWell(
                    onTap: _pickImage,
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: _selectedImageBytes != null
                          ? Image.memory(_selectedImageBytes!,
                          fit: BoxFit.cover)
                          : const Center(child: Text("Select Image")),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Message
                  TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: "Message",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Expiry Date
                  InkWell(
                    onTap: _pickDate,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: "Expiry Date",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        _selectedDate != null
                            ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                            : "Select Date",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Send Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: broadcastProvider.loading
                          ? null
                          : () async {
                        if (_messageController.text.isEmpty ||
                            _selectedDate == null ||
                            (_isLink
                                ? _linkController.text.isEmpty
                                : _selectedImageBytes == null)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "Please fill all fields")));
                          return;
                        }

                        if (_isLink) {
                          // Send Link Broadcast
                          await broadcastProvider.sendLink(
                            messageText:
                            _messageController.text.trim(),
                            linkUrl: _linkController.text.trim(),
                            expiresAt: DateFormat(
                                'yyyy-MM-dd HH:mm:ss')
                                .format(_selectedDate!),
                            token: token,
                          );
                        } else {
                          // Send Image Broadcast
                          await broadcastProvider.sendBroadcast(
                            imageBytes: _selectedImageBytes,
                            imageName: _selectedImageName,
                            messageText:
                            _messageController.text.trim(),
                            expiresAt: DateFormat(
                                'yyyy-MM-dd HH:mm:ss')
                                .format(_selectedDate!),
                            token: token,
                          );
                        }

                        if (broadcastProvider.error != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      broadcastProvider.error!)));
                        } else if (broadcastProvider.broadcast != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "Broadcast sent successfully!")));
                          setState(() {
                            _selectedImageBytes = null;
                            _selectedImageName = null;
                            _linkController.clear();
                            _messageController.clear();
                            _selectedDate = null;
                          });
                        }
                      },
                      child: broadcastProvider.loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Send Broadcast"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
