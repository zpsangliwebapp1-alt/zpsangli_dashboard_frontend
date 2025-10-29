import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../auth/provider/auth_provider.dart';
import '../provider/bdo_user_provider.dart';
import '../provider/create_bdo_provider.dart';
import '../repository/bdo_user_repository.dart';
import '../repository/create_bdo_repository.dart';
import '../../../../core/network/dio_client.dart';

// New imports for Create User + BDO dropdown
import '../repository/bdo_list_repository.dart';
import '../provider/bdo_list_provider.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  // Create BDO form controllers
  final _bdoFormKey = GlobalKey<FormState>();
  final _bdoNameController = TextEditingController();
  final _ceoUserIdController = TextEditingController(text: '2');

  // Create User form controllers
  final _userFormKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController(text: '123');
  final _bdoIdController = TextEditingController();
  int? _selectedBdoId;

  @override
  void initState() {
    super.initState();
    // Fetch the BDO list after build to ensure provider is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bdoProvider = context.read<BdoListProvider>();
      if (bdoProvider.bdoList.isEmpty) {
        bdoProvider.fetchBdos();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Existing BDO provider
        ChangeNotifierProvider(
          create: (context) {
            final authProvider = Provider.of<AuthProvider>(context, listen: false);
            final dioClient = DioClient(authProvider: authProvider);
            final repo = CreateBdoRepository(dioClient: dioClient);
            return CreateBdoProvider(repository: repo);
          },
        ),
        // New User creation provider
        ChangeNotifierProvider(
          create: (context) {
            final authProvider = Provider.of<AuthProvider>(context, listen: false);
            final dioClient = DioClient(authProvider: authProvider);
            final repo = CreateUserRepository(dioClient: dioClient);
            return CreateUserProvider(repository: repo);
          },
        ),
        // ✅ Fixed BDO list provider to pass AuthProvider
        ChangeNotifierProvider(
          create: (context) {
            final authProvider = Provider.of<AuthProvider>(context, listen: false);
            final dioClient = DioClient(authProvider: authProvider);
            final repo = BdoListRepository(
              dioClient: dioClient,
              authProvider: authProvider,
            );
            final provider = BdoListProvider(repository: repo);
            provider.fetchBdos(); // ✅ Fetch right after creation
            return provider;
          },
        ),

      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Accounts'),
          backgroundColor: Colors.blueAccent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _buildCreateBdoSection(context),
              const SizedBox(height: 40),
              const Divider(thickness: 1),
              const SizedBox(height: 20),
              _buildCreateUserSection(context),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------- CREATE BDO SECTION -----------------
  Widget _buildCreateBdoSection(BuildContext context) {
    return Consumer<CreateBdoProvider>(
      builder: (context, provider, _) {
        return Form(
          key: _bdoFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create BDO Account',
                style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _bdoNameController,
                decoration: const InputDecoration(
                  labelText: 'BDO Name',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Enter BDO name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ceoUserIdController,
                decoration: const InputDecoration(
                  labelText: 'CEO User ID',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Enter CEO User ID' : null,
              ),
              const SizedBox(height: 24),
              provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: () async {
                  if (_bdoFormKey.currentState!.validate()) {
                    await provider.createBdo(
                      _bdoNameController.text.trim(),
                      int.parse(_ceoUserIdController.text.trim()),
                    );

                    if (provider.errorMessage != null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(provider.errorMessage!),
                        backgroundColor: Colors.redAccent,
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('BDO created successfully!'),
                        backgroundColor: Colors.green,
                      ));
                      debugPrint('✅ BDO CREATED: ${provider.bdoResponse}');
                      // ✅ Refresh BDO dropdown after creating a new one
                      context.read<BdoListProvider>().fetchBdos();
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.blueAccent,
                ),
                child: const Text('Create BDO', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  // ----------------- CREATE USER SECTION -----------------
  Widget _buildCreateUserSection(BuildContext context) {
    return Consumer3<CreateUserProvider, BdoListProvider, AuthProvider>(
      builder: (context, userProvider, bdoProvider, auth, _) {
        return Form(
          key: _userFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create User Account',
                style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),

              // Username
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Enter username' : null,
              ),
              const SizedBox(height: 16),

              // Password
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Enter password' : null,
              ),
              const SizedBox(height: 16),

              // BDO Dropdown
              bdoProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: 'Select BDO',
                  border: OutlineInputBorder(),
                ),
                value: _selectedBdoId,
                items: bdoProvider.bdoList.map((bdo) {
                  return DropdownMenuItem<int>(
                    value: bdo['id'],
                    child: Text(bdo['name']),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedBdoId = val;
                    _bdoIdController.text = val?.toString() ?? '';
                  });
                },
                validator: (val) => val == null ? 'Select a BDO' : null,
              ),
              const SizedBox(height: 24),

              userProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: () async {
                  if (_userFormKey.currentState!.validate()) {
                    await userProvider.createUser(
                      username: _usernameController.text.trim(),
                      password: _passwordController.text.trim(),
                      bdoId: _selectedBdoId!,
                      parentCeoId: auth.userId ?? 2,
                    );

                    if (userProvider.errorMessage != null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(userProvider.errorMessage!),
                        backgroundColor: Colors.redAccent,
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('User created successfully!'),
                        backgroundColor: Colors.green,
                      ));
                      debugPrint('✅ USER CREATED: ${userProvider.userResponse}');
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.green,
                ),
                child: const Text('Create User', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }
}
