import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/complaint_request_model.dart';
import '../provider/complaint_provider.dart';

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controllers = <String, TextEditingController>{};
  bool _consentAccepted = false;

  @override
  void initState() {
    super.initState();
    final fields = [
      'name', 'mobile', 'email', 'aadhaar', 'address', 'village',
      'taluka', 'district', 'subject', 'description',
      'department', 'attachment', 'incidentDate'
    ];
    for (final f in fields) {
      _controllers[f] = TextEditingController();
    }
    Future.microtask(() => context.read<ComplaintProvider>().fetchComplaints());
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ComplaintProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Citizen Complaint Portal'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => provider.fetchComplaints(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => provider.fetchComplaints(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSummaryCards(context),
              const SizedBox(height: 30),
              _buildComplaintsList(provider),
              const SizedBox(height: 20),
              _buildFormSection(theme, provider),

            ],
          ),
        ),
      ),
    );
  }

  // 🟩 --- Summary Cards ---
  Widget _buildSummaryCards(BuildContext context) {
    final summaryData = [
      {'title': 'Total', 'count': 45, 'color': Colors.blue, 'icon': Icons.list_alt},
      {'title': 'Pending', 'count': 18, 'color': Colors.orange, 'icon': Icons.pending_actions},
      {'title': 'Approved', 'count': 27, 'color': Colors.green, 'icon': Icons.check_circle},
    ];

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.18, // 18% of screen height
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;

          // Dynamically adjust card width based on screen width
          final cardWidth = screenWidth < 400
              ? 140.0
              : screenWidth < 600
              ? 160.0
              : 200.0;

          final iconSize = screenWidth < 400 ? 24.0 : 28.0;
          final titleFontSize = screenWidth < 400 ? 12.0 : 14.0;
          final countFontSize = screenWidth < 400 ? 18.0 : 22.0;
          final padding = screenWidth < 400 ? 12.0 : 16.0;

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: padding),
            itemCount: summaryData.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, i) {
              final d = summaryData[i];
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: cardWidth,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      (d['color'] as Color).withOpacity(0.9),
                      (d['color'] as Color).withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: (d['color'] as Color).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(d['icon'] as IconData, color: Colors.white, size: iconSize),
                    const SizedBox(height: 8),
                    Text(
                      d['title'] as String,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${d['count']}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: countFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );

  }

  // 🟨 --- Complaint Form ---
  Widget _buildFormSection(ThemeData theme, ComplaintProvider provider) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Submit Complaint',
                    style: theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                if (provider.error != null)
                  Text(provider.error!,
                      style: const TextStyle(color: Colors.redAccent, fontSize: 14)),
                const SizedBox(height: 8),

                _buildTextField('name', 'Applicant Name'),
                _buildTextField('mobile', 'Mobile Number', keyboardType: TextInputType.phone),
                _buildTextField('email', 'Email', keyboardType: TextInputType.emailAddress),
                _buildTextField('aadhaar', 'Aadhaar Number'),
                _buildTextField('address', 'Address'),
                _buildTextField('village', 'Village'),
                _buildTextField('taluka', 'Taluka'),
                _buildTextField('district', 'District'),
                _buildTextField('subject', 'Complaint Subject'),
                _buildTextField('description', 'Complaint Description', maxLines: 3),
                _buildTextField('department', 'Concerned Department'),
                _buildTextField('attachment', 'Attachment URL'),
                _buildTextField('incidentDate', 'Incident Date (YYYY-MM-DD)'),

                const SizedBox(height: 8),
                Row(
                  children: [
                    Checkbox(
                      value: _consentAccepted,
                      onChanged: (v) => setState(() => _consentAccepted = v ?? false),
                    ),
                    const Expanded(
                        child: Text('I accept the consent to submit this complaint.')),
                  ],
                ),

                const SizedBox(height: 12),
                provider.isSubmitting
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton.icon(
                  onPressed: () => _submitComplaint(provider),
                  icon: const Icon(Icons.send),
                  label: const Text('Submit Complaint'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String key, String label,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: _controllers[key],
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
        validator: (v) => v == null || v.isEmpty ? '$label is required' : null,
      ),
    );
  }

  Future<void> _submitComplaint(ComplaintProvider provider) async {
    if (!_formKey.currentState!.validate()) return;
    if (!_consentAccepted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please accept consent')));
      return;
    }

    final req = ComplaintRequestModel(
      applicantName: _controllers['name']!.text.trim(),
      mobileNumber: _controllers['mobile']!.text.trim(),
      email: _controllers['email']!.text.trim(),
      aadhaarNumber: _controllers['aadhaar']!.text.trim(),
      address: _controllers['address']!.text.trim(),
      villageName: _controllers['village']!.text.trim(),
      taluka: _controllers['taluka']!.text.trim(),
      district: _controllers['district']!.text.trim(),
      complaintSubject: _controllers['subject']!.text.trim(),
      complaintDescription: _controllers['description']!.text.trim(),
      concernedDepartment: _controllers['department']!.text.trim(),
      attachmentUrl: _controllers['attachment']!.text.trim(),
      incidentDate: _controllers['incidentDate']!.text.trim(),
      consentAccepted: _consentAccepted,
    );

    await provider.submitComplaint(req);
    if (provider.error == null && provider.response != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(provider.response!.message)));
      _formKey.currentState!.reset();
      setState(() => _consentAccepted = false);
      provider.fetchComplaints();
    }
  }

// 🟦 --- Complaint List ---
  Widget _buildComplaintsList(ComplaintProvider provider) {
    if (provider.isFetching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.complaints.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sentiment_dissatisfied, color: Colors.grey.shade400, size: 60),
            const SizedBox(height: 10),
            const Text(
              'No complaints found',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 4),
            const Text(
              'You have not submitted any complaints yet.',
              style: TextStyle(fontSize: 14, color: Colors.black45),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📋 All Complaints',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.complaints.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = provider.complaints[index];
            return _buildComplaintCard(item);
          },
        ),
      ],
    );
  }

// 💬 --- Professional Complaint Card ---
  Widget _buildComplaintCard(Map<String, dynamic> item) {
    final status = (item['status'] ?? 'Pending').toString();
    final color = _getStatusColor(status);
    final isResolved = status.toLowerCase() == 'resolved';

    return InkWell(
      onTap: () => _showComplaintDetails(context, item),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🟢 Status Indicator
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isResolved ? Icons.check_circle : Icons.report_problem_rounded,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),

            // 📄 Complaint Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['complaintSubject'] ?? 'No Subject',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['complaintDescription'] ?? 'No description provided',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // 🗓️ Footer info (status, date)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          status.toUpperCase(),
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      Text(
                        item['incidentDate'] ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// 🟢 --- Status Color Helper ---
  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'resolved':
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.redAccent;
      default:
        return Colors.blueGrey;
    }
  }


  void _showComplaintDetails(BuildContext context, Map<String, dynamic> complaint) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(complaint['complaintSubject'] ?? 'Complaint Details',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              const Divider(),
              _buildDetailRow('Applicant', complaint['applicantName']),
              _buildDetailRow('Mobile', complaint['mobileNumber']),
              _buildDetailRow('Email', complaint['email']),
              _buildDetailRow('Department', complaint['concernedDepartment']),
              _buildDetailRow('Description', complaint['complaintDescription']),
              _buildDetailRow('Address', complaint['address']),
              _buildDetailRow('Village', complaint['villageName']),
              _buildDetailRow('District', complaint['district']),
              _buildDetailRow('Incident Date', complaint['incidentDate']),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text("$title: ${value ?? '-'}", style: const TextStyle(fontSize: 14)),
    );
  }
}
