// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:intl/intl.dart';
//
// import '../../features/all_roles/CEO_dashboard/provider/broadcast_provider.dart';
//
// class BroadcastFeed extends StatefulWidget {
//   const BroadcastFeed({super.key});
//
//   @override
//   State<BroadcastFeed> createState() => _BroadcastFeedState();
// }
//
// class _BroadcastFeedState extends State<BroadcastFeed> {
//   @override
//   void initState() {
//     super.initState();
//
//     // Load broadcasts once when the widget is first created
//     Future.microtask(() {
//       final provider = context.read<BroadcastProvider>();
//       if (provider.broadcasts.isEmpty) {
//         provider.loadBroadcasts();
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<BroadcastProvider>();
//
//     // ✅ Handle loading state
//     if (provider.loading) {
//       return const Center(child: CircularProgressIndicator());
//     }
//
//     // ✅ Handle error state
//     if (provider.error != null) {
//       return Center(child: Text(provider.error!));
//     }
//
//     final broadcasts = provider.broadcasts;
//
//     // ✅ No data state
//     if (broadcasts.isEmpty) {
//       return const Center(child: Text("सध्या कोणतेही पोस्ट उपलब्ध नाहीत."));
//     }
//
//     // ✅ Feed view (Instagram-style list)
//     return ListView.builder(
//       itemCount: broadcasts.length,
//       padding: const EdgeInsets.all(12),
//       itemBuilder: (context, index) {
//         final b = broadcasts[index];
//
//         return Card(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           elevation: 3,
//           margin: const EdgeInsets.symmetric(vertical: 10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // ============================
//               // 🔹 HEADER (Sender Info)
//               // ============================
//               ListTile(
//                 leading: CircleAvatar(
//                   backgroundColor: Colors.blue.shade300,
//                   child: const Icon(Icons.person, color: Colors.white),
//                 ),
//                 title: Text(
//                   // 👇 Change this to sender name when available
//                   b.messageText ?? "प्रशासन",
//
//                   // b.senderName ?? "प्रशासन",
//                   style: GoogleFonts.poppins(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 16,
//                   ),
//                 ),
//                 subtitle: Text(
//                   // Safely format date
//                   b.createdAt != null
//                       ? DateFormat('dd MMM yyyy, hh:mm a')
//                       .format(b.createdAt!)
//                       : '',
//                   style: GoogleFonts.poppins(
//                     fontSize: 12,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ),
//
//               // ============================
//               // 🔹 POST IMAGE (optional)
//               // ============================
//               if (b.imageUrl != null && b.imageUrl!.isNotEmpty)
//                 ClipRRect(
//                   borderRadius: const BorderRadius.vertical(
//                     top: Radius.zero,
//                     bottom: Radius.circular(8),
//                   ),
//                   child: Image.network(
//                     b.imageUrl!,
//                     height: 250,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) => Container(
//                       height: 250,
//                       color: Colors.grey.shade300,
//                       alignment: Alignment.center,
//                       child: const Icon(Icons.broken_image, size: 40),
//                     ),
//                   ),
//                 ),
//
//               // ============================
//               // 🔹 MESSAGE / CONTENT
//               // ============================
//               Padding(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 child: Text(
//                   b.messageText.isNotEmpty
//                       ? b.messageText
//                       : 'माहिती उपलब्ध नाही.',
//                   style: GoogleFonts.poppins(
//                     fontSize: 15,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ),
//
//               // ============================
//               // 🔹 LINK (optional)
//               // ============================
//               if (b.linkUrl != null && b.linkUrl!.isNotEmpty)
//                 Padding(
//                   padding:
//                   const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: GestureDetector(
//                       behavior: HitTestBehavior.translucent,
//                       onTap: () => _openLink(b.linkUrl!),
//                       child: Text(
//                         b.linkUrl!,
//                         style: GoogleFonts.poppins(
//                           color: Colors.blueAccent,
//                           decoration: TextDecoration.underline,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//
//               const SizedBox(height: 12),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   // ============================
//   // 🔹 Open external links safely
//   // ============================
//   Future<void> _openLink(String url) async {
//     final uri = Uri.parse(url);
//     try {
//       if (await canLaunchUrl(uri)) {
//         await launchUrl(uri, mode: LaunchMode.externalApplication);
//       } else {
//         _showSnackBar("लिंक उघडता येत नाही");
//       }
//     } catch (e) {
//       _showSnackBar("त्रुटी: लिंक उघडण्यात अडचण आली");
//     }
//   }
//
//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }
// }
