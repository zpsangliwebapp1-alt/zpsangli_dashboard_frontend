import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/create_department_provider.dart';
import '../repository/create_department_repository.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_strings.dart';

class CreateDepartmentScreen extends StatefulWidget {
  final String token;
  final String baseUrl;

  const CreateDepartmentScreen({
    super.key,
    required this.token,
    required this.baseUrl,
  });

  @override
  State<CreateDepartmentScreen> createState() => _CreateDepartmentScreenState();
}

class _CreateDepartmentScreenState extends State<CreateDepartmentScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bdoIdController = TextEditingController();
  final TextEditingController _additionalCeoUserIdController =
  TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _bdoIdController.dispose();
    _additionalCeoUserIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF5E35B1); // Deep Purple
    final secondaryColor = const Color(0xFF42A5F5); // Blue Accent
    final backgroundColor = Colors.grey.shade100;

    return ChangeNotifierProvider(
      create: (_) => CreateDepartmentProvider(
        repository: CreateDepartmentRepository(baseUrl: widget.baseUrl),
      ),
      child: Consumer<CreateDepartmentProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              title: const Text('Create Department',style: TextStyle(color: Colors.white),),
              backgroundColor: primaryColor,
              centerTitle: true,
              elevation: 2,
            ),
            body: Center(
              child: SingleChildScrollView(
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Card(
                    elevation: 10,
                    shadowColor: Colors.grey.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Create Department',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                              controller: _nameController,
                              label: 'Department Name',
                              hint: 'Enter department name'),
                          const SizedBox(height: 16),
                          _buildTextField(
                              controller: _bdoIdController,
                              label: 'BDO ID',
                              hint: 'Enter BDO ID',
                              keyboardType: TextInputType.number),
                          const SizedBox(height: 16),
                          _buildTextField(
                              controller: _additionalCeoUserIdController,
                              label: 'Additional CEO User ID',
                              hint: 'Enter user ID',
                              keyboardType: TextInputType.number),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: provider.loading
                                  ? null
                                  : () async {
                                final name =
                                _nameController.text.trim();
                                final bdoId = int.tryParse(
                                    _bdoIdController.text.trim()) ??
                                    0;
                                final additionalCeoUserId = int.tryParse(
                                    _additionalCeoUserIdController
                                        .text
                                        .trim()) ??
                                    0;

                                if (name.isEmpty) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Please enter a department name'),
                                    ),
                                  );
                                  return;
                                }

                                await provider.createDepartment(
                                  name: name,
                                  bdoId: bdoId,
                                  additionalCeoUserId: additionalCeoUserId,
                                  token: widget.token,
                                );

                                if (provider.error != null) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    SnackBar(
                                      content:
                                      Text('❌ ${provider.error}'),
                                    ),
                                  );
                                } else if (provider.createdDepartment !=
                                    null) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          '✅ Department created successfully!'),
                                    ),
                                  );
                                  _nameController.clear();
                                  _bdoIdController.clear();
                                  _additionalCeoUserIdController.clear();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                textStyle: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              child: provider.loading
                                  ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                                  : const Text('Create Department',style: TextStyle(color: Colors.white),),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final borderRadius = BorderRadius.circular(12);
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: const BorderSide(color: Color(0xFF5E35B1), width: 1.5),
        ),
        prefixIcon: const Icon(Icons.apartment_outlined,
            color: Color(0xFF5E35B1)),
      ),
    );
  }
}
