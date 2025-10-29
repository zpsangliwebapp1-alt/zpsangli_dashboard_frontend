import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../auth/provider/auth_provider.dart';
import '../provider/broadcast_provider.dart';

class AnnouncementDashboardScreen extends StatefulWidget {
  const AnnouncementDashboardScreen({super.key});

  @override
  State<AnnouncementDashboardScreen> createState() => _AnnouncementDashboardScreenState();
}

class _AnnouncementDashboardScreenState extends State<AnnouncementDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // --- Form Controllers ---
  Uint8List? _selectedImageBytes;
  String? _selectedImageName;
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  DateTime? _selectedDate;
  bool _isLink = false;
  bool _consentAccepted = true; // optional if needed

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() {
      final provider = context.read<BroadcastProvider>();
      if (provider.broadcasts.isEmpty) {
        provider.loadBroadcasts();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _messageController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);
    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _selectedImageBytes = result.files.single.bytes;
        _selectedImageName = result.files.single.name;
      });
    }
  }

  String? _selectedCategory;
  final List<String> _categories = [
    'New Schemes',
    'New Announcements',
    'Meetings',
    'Events',
    'Alerts / Notices',
    'Achievements',
    'Reminders',
    'Surveys / Feedback',
  ];


  Future<void> _pickDate() async {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final picked = await showDatePicker(
      context: context,
      initialDate: tomorrow,
      firstDate: tomorrow,
      lastDate: tomorrow.add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _openLink(String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showSnackBar("लिंक उघडता येत नाही");
      }
    } catch (e) {
      _showSnackBar("त्रुटी: लिंक उघडण्यात अडचण आली");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final broadcastProvider = context.watch<BroadcastProvider>();
    final authProvider = context.read<AuthProvider>();
    final token = authProvider.token ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Announcements & Broadcasts", style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w600)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.orangeAccent.shade700,
          labelColor: Colors.orangeAccent.shade700,
          unselectedLabelColor: Colors.grey.shade600,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: "Create Announcement"),
            Tab(text: "Broadcast Feed"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ---------------- Create Announcement Tab ----------------
          Center(
            child: SingleChildScrollView(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                padding: const EdgeInsets.all(24),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("New Announcement", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        Text("Share important updates with all departments.", style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade600)),
                        const SizedBox(height: 24),

                        // Toggle Image or Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ChoiceChip(
                              label: const Text("Image"),
                              selected: !_isLink,
                              selectedColor: Colors.orange.shade100,
                              labelStyle: GoogleFonts.poppins(fontWeight: !_isLink ? FontWeight.w600 : FontWeight.w400),
                              onSelected: (v) => setState(() => _isLink = !v),
                            ),
                            const SizedBox(width: 10),
                            ChoiceChip(
                              label: const Text("Link"),
                              selected: _isLink,
                              selectedColor: Colors.orange.shade100,
                              labelStyle: GoogleFonts.poppins(fontWeight: _isLink ? FontWeight.w600 : FontWeight.w400),
                              onSelected: (v) => setState(() => _isLink = v),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Conditional Input
                        _isLink
                            ? TextField(
                          controller: _linkController,
                          decoration: InputDecoration(
                            labelText: "Enter Link URL",
                            hintText: "https://example.com",
                            prefixIcon: const Icon(Icons.link_outlined),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        )
                            : InkWell(
                          onTap: _pickImage,
                          child: Container(
                            height: 180,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey.shade50,
                            ),
                            child: _selectedImageBytes != null
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.memory(_selectedImageBytes!, fit: BoxFit.cover),
                            )
                                : Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.image_outlined, size: 40, color: Colors.orangeAccent),
                                  const SizedBox(height: 8),
                                  Text("Tap to upload image", style: GoogleFonts.poppins(color: Colors.grey.shade600)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Message
                        TextField(
                          controller: _messageController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: "Message",
                            alignLabelWithHint: true,
                            hintText: "Enter announcement message...",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Expiry Date
                        InkWell(
                          onTap: _pickDate,
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: "Expiry Date",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : "Select Date",
                                  style: GoogleFonts.poppins(fontSize: 16),
                                ),
                                const Icon(Icons.calendar_today_outlined, size: 18, color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Category Dropdown
                        DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          decoration: InputDecoration(
                            labelText: "Select Category",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          items: _categories.map((category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value;
                              // Apply filter locally
                              broadcastProvider.filterByCategory(value!);
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a category';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),


                        // Send Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: broadcastProvider.loading
                                ? null
                                : () async {
                              if (_messageController.text.isEmpty ||
                                  _selectedDate == null ||
                                  (_isLink ? _linkController.text.isEmpty : _selectedImageBytes == null)) {
                                _showSnackBar("Please fill all required fields");
                                return;
                              }

                              if (_isLink) {
                                await broadcastProvider.sendLink(
                                  messageText: _messageController.text.trim(),
                                  linkUrl: _linkController.text.trim(),
                                  expiresAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(_selectedDate!),
                                  token: token,
                                  // category: 'New Announcements',
                                );
                              } else {
                                await broadcastProvider.sendBroadcast(
                                  imageBytes: _selectedImageBytes,
                                  imageName: _selectedImageName,
                                  messageText: _messageController.text.trim(),
                                  expiresAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(_selectedDate!),
                                  token: token,
                                  // category: 'New Announcements',
                                );
                              }

                              if (broadcastProvider.error != null) {
                                _showSnackBar(broadcastProvider.error!);
                              } else if (broadcastProvider.broadcast != null) {
                                _showSnackBar("Announcement sent successfully!");
                                setState(() {
                                  _selectedImageBytes = null;
                                  _selectedImageName = null;
                                  _linkController.clear();
                                  _messageController.clear();
                                  _selectedDate = null;
                                });
                              }
                            },
                            icon: const Icon(Icons.send_outlined),
                            label: broadcastProvider.loading
                                ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                                : const Text("Publish Announcement"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orangeAccent.shade700,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ---------------- Broadcast Feed Tab ----------------
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Consumer<BroadcastProvider>(
                builder: (context, provider, _) {
                  if (provider.loading) return const Center(child: CircularProgressIndicator());
                  if (provider.error != null) return Center(child: Text(provider.error!));
                  if (provider.broadcasts.isEmpty) return const Center(child: Text("सध्या कोणतेही पोस्ट उपलब्ध नाहीत."));

                  return Column(
                    children: provider.broadcasts.map((b) {
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: CircleAvatar(backgroundColor: Colors.blue.shade300, child: const Icon(Icons.person, color: Colors.white)),
                              title: Text(
                                (b.createdBy?.toString() ?? '0'),
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),

                              subtitle: Text(
                                b.createdAt != null ? DateFormat('dd MMM yyyy, hh:mm a').format(b.createdAt!) : '',
                                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                              ),
                            ),
                            if (b.imageUrl != null && b.imageUrl!.isNotEmpty)
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                                child: AspectRatio(
                                  aspectRatio: 16 / 9, // keeps image proportional and responsive
                                  child: Image.network(
                                    b.imageUrl!,
                                    width: double.infinity,
                                    fit: BoxFit.cover, // ensures full coverage without distortion
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        color: Colors.grey.shade200,
                                        alignment: Alignment.center,
                                        child: const CircularProgressIndicator(strokeWidth: 2),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      color: Colors.grey.shade300,
                                      alignment: Alignment.center,
                                      child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ),


                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Text(
                                b.messageText.isNotEmpty ? b.messageText : 'माहिती उपलब्ध नाही.',
                                style: GoogleFonts.poppins(fontSize: 15, color: Colors.black87),
                              ),
                            ),

                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              margin: const EdgeInsets.only(bottom: 8, left: 16),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                b.messageText ?? 'General',
                                style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.orange.shade800),
                              ),
                            ),

                            if (b.linkUrl != null && b.linkUrl!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () => _openLink(b.linkUrl!),
                                  child: Text(
                                    b.linkUrl!,
                                    style: GoogleFonts.poppins(color: Colors.blueAccent, decoration: TextDecoration.underline, fontSize: 14),
                                  ),
                                ),
                              ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
