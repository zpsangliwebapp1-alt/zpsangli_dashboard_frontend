import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../auth/provider/auth_provider.dart';
import '../provider/scheme_provider.dart';

class SchemeFormScreen extends StatefulWidget {
  const SchemeFormScreen({super.key});

  @override
  State<SchemeFormScreen> createState() => _SchemeFormScreenState();
}

class _SchemeFormScreenState extends State<SchemeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  // Keys for scrolling
  final _submittedSchemesKey = GlobalKey();
  final _schemeFormKey = GlobalKey();

  // ---------------- Controllers ----------------
  final _applicantNameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _aadhaarController = TextEditingController();
  final _addressController = TextEditingController();
  final _villageController = TextEditingController();
  final _talukaController = TextEditingController();
  final _districtController = TextEditingController();
  final _ageController = TextEditingController();
  final _genderController = TextEditingController();
  final _casteController = TextEditingController();
  final _annualIncomeController = TextEditingController();
  final _schemeNameController = TextEditingController();
  final _purposeController = TextEditingController();
  final _requiredDocsController = TextEditingController();
  final _bankAccountController = TextEditingController();
  final _ifscController = TextEditingController();

  bool _consentAccepted = false;

  // Dummy counts for development stage
  final int _dummyReceived = 12;
  final int _dummyPending = 5;
  final int _dummyApproved = 7;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final schemeProvider = context.read<SchemeProvider>();
      schemeProvider.fetchSchemes();
    });
  }

  @override
  void dispose() {
    _applicantNameController.dispose();
    _fatherNameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _aadhaarController.dispose();
    _addressController.dispose();
    _villageController.dispose();
    _talukaController.dispose();
    _districtController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _casteController.dispose();
    _annualIncomeController.dispose();
    _schemeNameController.dispose();
    _purposeController.dispose();
    _requiredDocsController.dispose();
    _bankAccountController.dispose();
    _ifscController.dispose();
    super.dispose();
  }

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator ?? (val) => val!.isEmpty ? 'Required field' : null,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, List<Widget> children) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? '-',
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountCard(String title, int count, Color startColor, Color endColor) {
    return Expanded(
      child: Container(
        height: 100,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [startColor, endColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$count',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final schemeProvider = context.watch<SchemeProvider>();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Scheme Application',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        elevation: 2,
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ---------------- Counts Cards ----------------
            Row(
              children: [
                _buildCountCard('Received', _dummyReceived, Colors.blueAccent, Colors.lightBlue),
                _buildCountCard('Pending', _dummyPending, Colors.orangeAccent, Colors.deepOrange),
                _buildCountCard('Approved', _dummyApproved, Colors.green, Colors.lightGreen),
              ],
            ),

            const SizedBox(height: 16),

            // ---------------- Gradient Navigation Cards ----------------
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _scrollToSection(_submittedSchemesKey),
                    child: Container(
                      height: 100,
                      margin: const EdgeInsets.only(right: 8, bottom: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [Colors.blueAccent, Colors.lightBlue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2))
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Submitted Schemes',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _scrollToSection(_schemeFormKey),
                    child: Container(
                      height: 100,
                      margin: const EdgeInsets.only(left: 8, bottom: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [Colors.orangeAccent, Colors.deepOrange],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2))
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Scheme Application',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ---------------- Submitted Schemes List ----------------
            Container(
              key: _submittedSchemesKey,
              child: _buildSectionCard('Submitted Schemes', [
                if (schemeProvider.status == SchemeStatus.loading)
                  const Center(child: CircularProgressIndicator()),
                if (schemeProvider.schemeList.isEmpty &&
                    schemeProvider.status != SchemeStatus.loading)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'No schemes submitted yet.',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                ...schemeProvider.schemeList.map((scheme) {
                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      title: Text(
                        scheme['schemeName'] ?? 'Unnamed Scheme',
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      subtitle: Text(
                        'Applicant: ${scheme['applicantName'] ?? '-'}\nSubmitted: ${scheme['createdAt']?.toString().split('T').first ?? '-'}',
                        style:
                        const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                      children: [
                        DefaultTabController(
                          length: 2,
                          child: Column(
                            children: [
                              const TabBar(
                                labelColor: Colors.blueAccent,
                                unselectedLabelColor: Colors.grey,
                                indicatorColor: Colors.blueAccent,
                                tabs: [
                                  Tab(text: 'Personal Info'),
                                  Tab(text: 'Scheme Details'),
                                ],
                              ),
                              SizedBox(
                                height: 280,
                                child: TabBarView(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            _buildDetailRow('Applicant Name',
                                                scheme['applicantName']),
                                            _buildDetailRow('Father/Husband Name',
                                                scheme['fatherOrHusbandName']),
                                            _buildDetailRow(
                                                'Mobile', scheme['mobileNumber']),
                                            _buildDetailRow(
                                                'Email', scheme['email']),
                                            _buildDetailRow(
                                                'Aadhaar', scheme['aadhaarNumber']),
                                            _buildDetailRow(
                                                'Address', scheme['address']),
                                            _buildDetailRow(
                                                'Village', scheme['villageName']),
                                            _buildDetailRow('Taluka', scheme['taluka']),
                                            _buildDetailRow(
                                                'District', scheme['district']),
                                            _buildDetailRow(
                                                'Age', scheme['age']?.toString()),
                                            _buildDetailRow(
                                                'Gender', scheme['gender']),
                                            _buildDetailRow(
                                                'Caste', scheme['caste']),
                                            _buildDetailRow(
                                                'Annual Income',
                                                scheme['annualIncome']?.toString()),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            _buildDetailRow(
                                                'Scheme Name', scheme['schemeName']),
                                            _buildDetailRow('Purpose', scheme['purpose']),
                                            _buildDetailRow(
                                              'Required Documents',
                                              (scheme['requiredDocuments']
                                              as List<dynamic>?)
                                                  ?.join(', '),
                                            ),
                                            _buildDetailRow('Bank Account',
                                                scheme['bankAccountNumber']),
                                            _buildDetailRow(
                                                'IFSC', scheme['ifscCode']),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ]),
            ),

            // ---------------- Scheme Form ----------------
            Container(
              key: _schemeFormKey,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSectionCard('Personal Information', [
                      _buildTextField(
                          controller: _applicantNameController,
                          label: 'Applicant Name'),
                      _buildTextField(
                          controller: _fatherNameController,
                          label: 'Father / Husband Name'),
                      _buildTextField(
                        controller: _mobileController,
                        label: 'Mobile Number',
                        keyboardType: TextInputType.phone,
                        validator: (val) => val!.length < 10
                            ? 'Enter valid mobile number'
                            : null,
                      ),
                      _buildTextField(
                          controller: _emailController,
                          label: 'Email',
                          keyboardType: TextInputType.emailAddress),
                      _buildTextField(
                        controller: _aadhaarController,
                        label: 'Aadhaar Number',
                        keyboardType: TextInputType.number,
                        validator: (val) =>
                        val!.length != 12 ? 'Invalid Aadhaar number' : null,
                      ),
                      _buildTextField(
                          controller: _addressController, label: 'Address'),
                      _buildTextField(
                          controller: _villageController, label: 'Village'),
                      _buildTextField(
                          controller: _talukaController, label: 'Taluka'),
                      _buildTextField(
                          controller: _districtController, label: 'District'),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                                controller: _ageController,
                                label: 'Age',
                                keyboardType: TextInputType.number),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildTextField(
                                controller: _genderController, label: 'Gender'),
                          ),
                        ],
                      ),
                      _buildTextField(
                          controller: _casteController, label: 'Caste'),
                      _buildTextField(
                          controller: _annualIncomeController,
                          label: 'Annual Income',
                          keyboardType: TextInputType.number),
                    ]),
                    _buildSectionCard('Scheme Details', [
                      _buildTextField(
                          controller: _schemeNameController, label: 'Scheme Name'),
                      _buildTextField(
                          controller: _purposeController, label: 'Purpose'),
                      _buildTextField(
                        controller: _requiredDocsController,
                        label: 'Required Documents',
                        hint: 'Separate with commas (e.g., Aadhaar, PAN, Photo)',
                      ),
                      _buildTextField(
                          controller: _bankAccountController,
                          label: 'Bank Account Number'),
                      _buildTextField(
                          controller: _ifscController, label: 'IFSC Code'),
                      const SizedBox(height: 10),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                            'I confirm that the information provided is correct and consent to submit this application.'),
                        value: _consentAccepted,
                        onChanged: (val) =>
                            setState(() => _consentAccepted = val ?? false),
                      ),
                    ]),
                    const SizedBox(height: 10),
                    schemeProvider.status == SchemeStatus.loading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton.icon(
                      icon: const Icon(Icons.send),
                      label: const Text('Submit Application',
                          style: TextStyle(fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        if (!_consentAccepted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Please accept the consent checkbox')),
                          );
                          return;
                        }

                        if (_formKey.currentState?.validate() ?? false) {
                          final int age =
                              int.tryParse(_ageController.text.trim()) ?? 0;
                          final int annualIncome =
                              int.tryParse(_annualIncomeController.text
                                  .trim()) ??
                                  0;
                          final List<String> requiredDocs =
                          _requiredDocsController.text
                              .split(',')
                              .map((doc) => doc.trim())
                              .where((doc) => doc.isNotEmpty)
                              .toList();

                          schemeProvider.submitScheme(
                            applicantName:
                            _applicantNameController.text.trim(),
                            fatherOrHusbandName:
                            _fatherNameController.text.trim(),
                            mobileNumber: _mobileController.text.trim(),
                            email: _emailController.text.trim(),
                            aadhaarNumber: _aadhaarController.text.trim(),
                            address: _addressController.text.trim(),
                            villageName: _villageController.text.trim(),
                            taluka: _talukaController.text.trim(),
                            district: _districtController.text.trim(),
                            age: age,
                            gender: _genderController.text.trim(),
                            caste: _casteController.text.trim(),
                            annualIncome: annualIncome,
                            schemeName: _schemeNameController.text.trim(),
                            purpose: _purposeController.text.trim(),
                            requiredDocuments: requiredDocs,
                            bankAccountNumber:
                            _bankAccountController.text.trim(),
                            ifscCode: _ifscController.text.trim(),
                            consentAccepted: _consentAccepted,
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- FormCounts Class ----------------
class FormCounts {
  final int received;
  final int pending;
  final int approved;

  FormCounts({required this.received, required this.pending, required this.approved});
}
