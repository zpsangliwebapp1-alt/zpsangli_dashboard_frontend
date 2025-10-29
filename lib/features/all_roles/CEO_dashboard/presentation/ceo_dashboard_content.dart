// 📁 features/all_roles/CEO_dashboard/presentation/ceo_dashboard_content.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/network/dio_client.dart';
import '../../../auth/repository/auth_repository.dart';
import '../controller/ceo_dashboard_controller.dart';
import '../widgets/filter_row.dart';
import '../provider/broadcast_provider.dart';
import 'department_overview_card.dart';

class CeoDashboardContent extends StatefulWidget {
  final bool mobile;
  const CeoDashboardContent({super.key, this.mobile = false});

  @override
  State<CeoDashboardContent> createState() => _CeoDashboardContentState();
}

class _CeoDashboardContentState extends State<CeoDashboardContent> {
  @override
  void initState() {
    super.initState();
    final ctrl = Provider.of<CeoDashboardController>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ctrl.init(); // ✅ runs once only
    });
  }



  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<CeoDashboardController>();
    return ctrl.isLoading
        ? const Center(child: CircularProgressIndicator())
        : const _DashboardBody();
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody();

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<CeoDashboardController>();
    final block = ctrl.selectedBlock;
    final department = ctrl.selectedDepartment;

    final monthlyTotals = {
      for (var item in ctrl.items)
        item.name: {
          "financial": item.financial ?? 0.0,
          "achievement": item.achievement ?? 0.0,
          "target": item.target ?? 0.0,
        }
    };

    final satisfactionData = {
      for (var item in ctrl.items) item.name: item.achievement ?? 0.0,
    };

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FilterRow(),
            const SizedBox(height: 16),
            DepartmentOverviewCard(
              block: block,
              department: department,
              // monthlyTotals: monthlyTotals,
              lastUpdated: DateTime.now(),
              // selectedMonth: ctrl.selectedMonth,
              // selectedYear: ctrl.selectedYear,
              satisfactionData: satisfactionData,
              departmentId: ctrl.selectedDepartmentId ?? 0,
            ),
            const SizedBox(height: 24),
            const BroadcastFeed(),
          ],
        ),
      ),
    );
  }
}

class BroadcastFeed extends StatefulWidget {
  const BroadcastFeed({super.key});

  @override
  State<BroadcastFeed> createState() => _BroadcastFeedState();
}

class _BroadcastFeedState extends State<BroadcastFeed> {
  late final userRepository = AuthRepository(DioClient());

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = context.read<BroadcastProvider>();
      if (provider.broadcasts.isEmpty) {
        provider.loadBroadcasts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BroadcastProvider>();

    if (provider.loading) return const Center(child: CircularProgressIndicator());
    if (provider.error != null) return Center(child: Text(provider.error!));

    final broadcasts = provider.broadcasts;
    if (broadcasts.isEmpty) {
      return const Center(child: Text("सध्या कोणतेही पोस्ट उपलब्ध नाहीत."));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: broadcasts.length,
      padding: const EdgeInsets.all(12),
      itemBuilder: (context, index) {
        final b = broadcasts[index];
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<String?>(
                future: userRepository.getUsernameById(
                  (b.createdBy is int)
                      ? b.createdBy as int
                      : int.tryParse(b.createdBy?.toString() ?? '0') ?? 0,
                ),
                builder: (context, snapshot) {
                  final username = snapshot.data ?? 'Unknown User';
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade300,
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      username,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      b.createdAt != null
                          ? DateFormat('dd MMM yyyy, hh:mm a').format(b.createdAt!)
                          : '',
                      style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                    ),
                  );
                },
              ),
              if (b.imageUrl != null && b.imageUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
                  child: Image.network(
                    b.imageUrl!,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 250,
                      color: Colors.grey.shade300,
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image, size: 40),
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
              if (b.linkUrl != null && b.linkUrl!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => _openLink(b.linkUrl!),
                    child: Text(
                      b.linkUrl!,
                      style: GoogleFonts.poppins(
                        color: Colors.blueAccent,
                        decoration: TextDecoration.underline,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }


}
