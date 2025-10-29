import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/registration_request.dart';
import '../../provider/registration_provider.dart';
import '../../provider/auth_provider.dart';
import '../../provider/role_provider.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _usernameCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  int? selectedRoleId;

  @override
  void initState() {
    super.initState();
    // Load roles on screen start
    Future.microtask(() =>
        context.read<RoleProvider>().fetchRoles());
  }

  @override
  Widget build(BuildContext context) {
    final registrationProvider = context.watch<RegistrationProvider>();
    final authProvider = context.read<AuthProvider>();
    final roleProvider = context.watch<RoleProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Role Based Registration')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _usernameCtrl,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordCtrl,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),

            // 🔹 Dropdown for roles
            roleProvider.isLoading
                ? const CircularProgressIndicator()
                : DropdownButton<int>(
              isExpanded: true,
              hint: const Text('Select Role'),
              value: selectedRoleId,
              items: roleProvider.roles
                  .map((role) => DropdownMenuItem<int>(
                value: role.id,
                child: Text(role.name),
              ))
                  .toList(),
              onChanged: (val) => setState(() => selectedRoleId = val),
            ),

            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: registrationProvider.isLoading || selectedRoleId == null
                  ? null
                  : () async {
                // Ensure token is fresh
                bool refreshed = await authProvider.refreshTokenIfNeeded();
                final token = authProvider.token;
                if (token == null || token.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Authentication failed')),
                  );
                  return;
                }

                // ✅ Get current CEO id from AuthProvider
                final parentCeoId = authProvider.roleId == 1 ? authProvider.roleId! : 0;

                final req = RegistrationRequest(
                  username: _usernameCtrl.text.trim(),
                  password: _passwordCtrl.text.trim(),
                  roleId: selectedRoleId!,
                  parentCeoId: parentCeoId,  // <- dynamically set parent CEO id
                );

                await registrationProvider.registerUser(
                  request: req,
                  token: token,
                );

                if (registrationProvider.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(registrationProvider.errorMessage!)),
                  );
                } else if (registrationProvider.registrationResponse != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User Registered Successfully')),
                  );
                }
              },
              child: registrationProvider.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
