// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../auth/provider/auth_provider.dart';
// import '../repository/complaint_repository.dart';
// import '../../../../core/network/dio_client.dart';
// import 'package:dio/dio.dart';
//
// class ComplaintListScreen extends StatefulWidget {
//   const ComplaintListScreen({super.key});
//
//   @override
//   State<ComplaintListScreen> createState() => _ComplaintListScreenState();
// }
//
// class _ComplaintListScreenState extends State<ComplaintListScreen> {
//   bool _loading = true;
//   String? _error;
//   List<dynamic> _complaints = [];
//
//   Future<void> _fetchComplaints() async {
//     setState(() {
//       _loading = true;
//       _error = null;
//     });
//
//     try {
//       final authProvider = context.read<AuthProvider>();
//       final dioClient = DioClient();
//       final repository = ComplaintRepository(
//         dioClient: dioClient,
//         authProvider: authProvider,
//       );
//
//       // 🔐 Get latest token
//       final token = authProvider.token;
//       print('🔑 Token in use: $token');
//
//       if (token == null || token.isEmpty) {
//         setState(() {
//           _error = 'Please login again.';
//         });
//         return;
//       }
//
//       // 🔥 Fetch complaints
//       final response = await dioClient.get(
//         'https://rdprgovapi.atyoureye.com/api/applications/complaints',
//         options: Options(
//           headers: {
//             'Accept': 'text/plain',
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );
//
//       if (response.statusCode == 200 && response.data is List) {
//         setState(() {
//           _complaints = response.data;
//         });
//       } else {
//         setState(() {
//           _error = 'Unexpected response format or status: ${response.statusCode}';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _error = e.toString();
//       });
//     } finally {
//       setState(() {
//         _loading = false;
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchComplaints();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Complaints List'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: _fetchComplaints,
//           ),
//         ],
//       ),
//       body: _loading
//           ? const Center(child: CircularProgressIndicator())
//           : _error != null
//           ? Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Text(
//             _error!,
//             style: const TextStyle(color: Colors.red, fontSize: 16),
//             textAlign: TextAlign.center,
//           ),
//         ),
//       )
//           : _complaints.isEmpty
//           ? const Center(
//         child: Text(
//           'No complaints found.',
//           style: TextStyle(fontSize: 16),
//         ),
//       )
//           : ListView.builder(
//         itemCount: _complaints.length,
//         itemBuilder: (context, index) {
//           final item = _complaints[index];
//           return Card(
//             margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             elevation: 3,
//             child: ListTile(
//               leading: CircleAvatar(
//                 backgroundColor: Colors.blue.shade100,
//                 child: Text(item['id'].toString()),
//               ),
//               title: Text(item['complaintSubject'] ?? 'No Subject'),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Applicant: ${item['applicantName'] ?? 'N/A'}'),
//                   Text('Mobile: ${item['mobileNumber'] ?? 'N/A'}'),
//                   Text('Department: ${item['concernedDepartment'] ?? 'N/A'}'),
//                   Text('Date: ${item['incidentDate'] ?? '-'}'),
//                 ],
//               ),
//               trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//               onTap: () {
//                 _showComplaintDetails(context, item);
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   void _showComplaintDetails(BuildContext context, Map<String, dynamic> complaint) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text(complaint['complaintSubject'] ?? 'Complaint Details'),
//         content: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildDetailRow('Applicant', complaint['applicantName']),
//               _buildDetailRow('Mobile', complaint['mobileNumber']),
//               _buildDetailRow('Email', complaint['email']),
//               _buildDetailRow('Department', complaint['concernedDepartment']),
//               _buildDetailRow('Description', complaint['complaintDescription']),
//               _buildDetailRow('Address', complaint['address']),
//               _buildDetailRow('Village', complaint['villageName']),
//               _buildDetailRow('District', complaint['district']),
//               _buildDetailRow('Incident Date', complaint['incidentDate']),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Close'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(String title, dynamic value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Text(
//         "$title: ${value ?? '-'}",
//         style: const TextStyle(fontSize: 14),
//       ),
//     );
//   }
// }
