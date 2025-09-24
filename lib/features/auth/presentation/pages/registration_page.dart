// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:zp_sangali_dashboard_flutter/core/widgets/responsive_texts.dart';
//
// import '../../../../core/constants/app_strings.dart';
// import '../../../../core/constants/app_text_styles.dart';
// import '../../../../core/widgets/responsive_layout.dart';
// import '../../../../routing/route_names.dart';
//
// class  RegistartionPage extends StatelessWidget {
//   const RegistartionPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ResponsiveLayout(
//       mobile: const _RegistartionMobile(),
//       tablet: const _RegistartionTablet(),
//       desktop: const _RegistartionDesktop(),
//     );
//   }
// }
//
// /// ---------------- MOBILE ----------------
// class _RegistartionMobile extends StatelessWidget {
//   const _RegistartionMobile();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false, // 👈 stops background from shifting
//
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           // Fullscreen background image (different for mobile)
//           Image.asset(
//             AppStrings.mobilelogin_page_image, // 👈 add new image in AppStrings
//             fit: BoxFit.fitHeight,
//           ),
//
//
//
//           // Centered scrollable form
//           Center(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(24),
//               child: const _LoginForm(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// ---------------- TABLET ----------------
// class _RegistartionTablet extends StatelessWidget {
//   const _RegistartionTablet();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false, // 👈 stops background from shifting
//
//       body: Row(
//         children: [
//           const Expanded(flex: 5, child: _LoginForm()),
//           Expanded(
//             flex: 5,
//             child: Image.asset(AppStrings.login_page_image, fit: BoxFit.cover),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// ---------------- DESKTOP ----------------
// class _RegistartionDesktop extends StatelessWidget {
//   const _RegistartionDesktop();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Row(
//         children: [
//           // 🔹 Left: Form Panel with Glassmorphism
//           Expanded(
//             flex: 4,
//             child: Center(
//               child: ConstrainedBox(
//                 constraints: const BoxConstraints(maxWidth: 500),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: BackdropFilter(
//                     filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                     child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
//                   decoration: BoxDecoration(
//                     // 🔹 Polished Gradient Background
//                     gradient: LinearGradient(
//                       colors: [
//                         Colors.white.withOpacity(0.95),
//                         Colors.grey[100]!,
//                       ],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(color: Colors.grey.shade200, width: 1.2),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.08),
//                         blurRadius: 20,
//                         offset: const Offset(0, 10),
//                       ),
//                     ],
//                   ),
//                   child: SingleChildScrollView(
//                     child: const _LoginFormDesktop(),
//                   ),
//                 ),
//
//                   ),
//                 ),
//               ),
//             ),
//           ),
//
//           // 🔹 Right: Hero Section
//           Expanded(
//             flex: 6,
//             child: Stack(
//               fit: StackFit.expand,
//               children: [
//                 Image.asset(AppStrings.login_page_image, fit: BoxFit.cover),
//                 Container(color: Colors.black.withOpacity(0.4)),
//
//                 // Text overlay
//                 Positioned(
//                   bottom: 60,
//                   left: 60,
//                   right: 60,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "✨ Welcome to Giants Welfare",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: context.scaledFont(28),
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       const Text(
//                         "Building stronger communities together.",
//                         style: TextStyle(
//                           color: Colors.white70,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// ---------------- DESKTOP LOGIN FORM ----------------
// class _LoginFormDesktop extends StatefulWidget {
//   const _LoginFormDesktop();
//
//   @override
//   State<_LoginFormDesktop> createState() => _LoginFormDesktopState();
// }
//
// class _LoginFormDesktopState extends State<_LoginFormDesktop> {
//   bool _isChecked = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         // Logo
//         ClipOval(
//           child: Image.asset(
//             AppStrings.appLogo,
//             height: 120,
//             width: 120,
//             fit: BoxFit.cover,
//           ),
//         ),
//
//         const SizedBox(height: 20),
//         Text("Create an account",
//             style: AppTextStyles.headline1(context)
//                 ?.copyWith(fontWeight: FontWeight.bold)),
//         const SizedBox(height: 6),
//         Text("Join Our Community",
//             style: AppTextStyles.body(context)?.copyWith(color: Colors.grey[700])),
//         const SizedBox(height: 24),
//
//         // Tab Section
//         DefaultTabController(
//           length: 4,
//           child: Column(
//             children: [
//               Container(
//                 height: 50,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.green, width: 1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: TabBar(
//                   indicatorSize: TabBarIndicatorSize.tab,
//                   dividerColor: Colors.transparent,
//                   indicator: BoxDecoration(
//                     color: Colors.green.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   labelColor: Colors.green[900],
//                   unselectedLabelColor: Colors.grey[600],
//                   tabs: const [
//                     Tab(text: "Federation"),
//                     Tab(text: "Unit"),
//                     Tab(text: "Group"),
//                     Tab(text: "Public"),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 32),
//
//               SizedBox(
//                 height: 80,
//                 child: TabBarView(
//                   children: const [
//                     _RoleForm(role: "Federation"),
//                     _RoleForm(role: "Unit"),
//                     _RoleForm(role: "Group"),
//                     _RoleForm(role: "Public"),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//
//         const SizedBox(height: 24),
//
//         // Form Fields
//         _buildTextField("Full name", Icons.person_outline),
//         const SizedBox(height: 16),
//         _buildTextField("Email / Mobile Number", Icons.email_outlined),
//         const SizedBox(height: 16),
//         _buildTextField("Password", Icons.lock_outline, isPassword: true),
//
//         const SizedBox(height: 20),
//
//         // Checkbox
//         Row(
//           children: [
//             Checkbox(
//               value: _isChecked,
//               activeColor: Colors.red,
//               onChanged: (v) => setState(() => _isChecked = v ?? false),
//             ),
//             const Expanded(
//               child: Text("I agree to the Terms & Conditions"),
//             )
//           ],
//         ),
//
//         const SizedBox(height: 24),
//
//         // Submit Button
//         SizedBox(
//           width: double.infinity,
//           child: Container(
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Color(0xFFe53935), Color(0xFFff6f61)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: ElevatedButton(
//               onPressed: _isChecked ? () => print("Submitted ✅") : null,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.transparent,
//                 shadowColor: Colors.transparent,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12)),
//               ),
//               child: Text(
//                 "Submit",
//                 style: AppTextStyles.button(context)
//                     ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//         ),
//
//         const SizedBox(height: 30),
//
//         // Link
//         TextButton(
//           onPressed: () => Navigator.of(context).pushNamed(RouteNames.login),
//           child: Text(
//             "Existing User? Login",
//             style: AppTextStyles.link(context)?.copyWith(
//               color: Colors.grey[700],
//               fontSize: 14,
//               decoration: TextDecoration.underline,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTextField(String hint, IconData icon,
//       {bool isPassword = false}) {
//     return TextField(
//       obscureText: isPassword,
//       decoration: InputDecoration(
//         hintText: hint,
//         prefixIcon: Icon(icon, color: Colors.grey[600]),
//         filled: true,
//         fillColor: Colors.grey[100],
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 20,
//           vertical: 18,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
//         ),
//       ),
//     );
//   }
// }
//
//
//
// /// ---------------- LOGIN FORM ----------------
// class _LoginForm extends StatefulWidget {
//   const _LoginForm();
//
//   @override
//   State<_LoginForm> createState() => _LoginFormState();
// }
//
// class _LoginFormState extends State<_LoginForm> {
//   bool _isChecked = false; // 👈 state for checkbox
//
//   @override
//   Widget build(BuildContext context) {
//     return ConstrainedBox(
//       constraints: const BoxConstraints(maxWidth: 320), // 👈 Limit width
//       child: Center(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // 👇 Logo
//             ClipOval(
//               child: Image.asset(
//                 AppStrings.appLogo,
//                 height: 140,
//                 width: 140,
//                 fit: BoxFit.cover,
//               ),
//             ),
//
//             // const SizedBox(height: ),
//             Text("Create an account", style: AppTextStyles.headline2(context)),
//             const SizedBox(height: 8),
//             Text("Join Our Community",
//                 style: AppTextStyles.bodySmall(context)),
//             const SizedBox(height: 12),
//
//             // 🔹 TabBar Section
//         DefaultTabController(
//           length: 4,
//           child: Column(
//             children: [
//               Container(
//                 height: 50,
//                 width: MediaQuery.of(context).size.width/1,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.green, width: 1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: TabBar(
//                   isScrollable: false, // 👈 makes all tabs equal width
//                   indicatorSize: TabBarIndicatorSize.tab, // 👈 indicator matches tab width
//                   dividerColor: Colors.transparent,
//                   indicator: BoxDecoration(
//                     color: Colors.pink.withOpacity(0.2), // selected bg
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   labelColor: Colors.green[900],
//                   unselectedLabelColor: Colors.green[900],
//                   labelStyle: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                   ),
//                   tabs: const [
//                     Tab(text: "Federation"),
//                     Tab(text: "Unit"),
//                     Tab(text: "Group"),
//                     Tab(text: "Public"),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 30),
//
//               SizedBox(
//                 height: MediaQuery.of(context).size.width < 600 ? 40 : 80,
//                 // <600 = mobile, >=600 = tablet/desktop
//                 child: TabBarView(
//                   children: const [
//                     _RoleForm(role: "Federation"),
//                     _RoleForm(role: "Unit"),
//                     _RoleForm(role: "Group"),
//                     _RoleForm(role: "Public"),
//                   ],
//                 ),
//               ),
//
//
//             ],
//           ),
//         ),
//
//             const SizedBox(height: 20),
//
//             // Name field
//             SizedBox(
//               width: 330,
//               child: TextField(
//                 decoration: InputDecoration(
//                   hintText: "Full name",
//                   hintStyle: AppTextStyles.bodySmall(context)?.copyWith(
//                     color: Colors.grey[600],
//                   ),
//                   filled: true,
//                   fillColor: Colors.grey[100],
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 14,
//                   ),
//                   prefixIcon: Icon(
//                     Icons.person_outline, // 👈 Full name icon
//                     color: Colors.grey[600],
//                   ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
//                   ),
//                 ),
//               ),
//             ),
//
//
//             const SizedBox(height: 16),
//
//             // Email field
//             SizedBox(
//               width: 330,
//               child: TextField(
//                 decoration: InputDecoration(
//                   hintText: "Email / Mobile Number",
//                   hintStyle: AppTextStyles.bodySmall(context)?.copyWith(
//                     color: Colors.grey[600],
//                   ),
//                   filled: true,
//                   fillColor: Colors.grey[100],
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 14,
//                   ),
//                   prefixIcon: Icon(
//                     Icons.email_outlined, // 👈 email icon
//                     color: Colors.grey[600],
//                   ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
//                   ),
//                 ),
//               ),
//             ),
//
//
//             const SizedBox(height: 16),
//
//             // Password field
//             SizedBox(
//               width: 330,
//               child: TextField(
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   hintText: "Password",
//                   hintStyle: AppTextStyles.bodySmall(context)?.copyWith(
//                     color: Colors.grey[600],
//                   ),
//                   filled: true,
//                   fillColor: Colors.grey[100],
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 14,
//                   ),
//                   prefixIcon: Icon(
//                     Icons.lock_outline, // 🔒 Password icon
//                     color: Colors.grey[600],
//                   ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
//                   ),
//                 ),
//               ),
//             ),
//
//
//             const SizedBox(height: 12),
//
//             // 👇 Checkbox
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Checkbox(
//                   value: _isChecked,
//                   activeColor: Colors.amber,
//                   onChanged: (value) {
//                     setState(() {
//                       _isChecked = value ?? false;
//                     });
//                   },
//                 ),
//                 Flexible(
//                   child: Text(
//                     "I agree to the Terms & Conditions",
//                     style: AppTextStyles.bodySmall(context),
//                   ),
//                 ),
//               ],
//             ),
//
//
//             const SizedBox(height: 20),
//             // Submit button (enabled only when checked)
//             // SizedBox(
//             //   width: 180,
//             //   child: ElevatedButton(
//             //     onPressed: _isChecked
//             //         ? () {
//             //       // 👈 Only works when checkbox is true
//             //       print("Form Submitted ✅");
//             //     }
//             //         : null, // 👈 disables button
//             //     style: ElevatedButton.styleFrom(
//             //       backgroundColor: Colors.amber,
//             //       foregroundColor: Colors.black,
//             //       elevation: 3,
//             //       padding: const EdgeInsets.symmetric(vertical: 14),
//             //       shape: RoundedRectangleBorder(
//             //         borderRadius: BorderRadius.circular(12),
//             //       ),
//             //     ),
//             //     child: Text(
//             //       "Submit",
//             //       style: AppTextStyles.button(context)?.copyWith(
//             //         fontWeight: FontWeight.bold,
//             //       ),
//             //     ),
//             //   ),
//             // ),
//             //
//             // const SizedBox(height: 20),
//
//             // Bottom links
//             SizedBox(
//               width: 180,
//               child: Container(
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [
//                       Color(0xFFe53935), // 🔴 Deep Red
//                       Color(0xFFe53935), // 🌸 Soft Red/Pink
//                       // Color(0xFFFFFFFF), // ⚪ White for polish
//                     ],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.red.withOpacity(0.3),
//                       blurRadius: 6,
//                       offset: const Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: ElevatedButton(
//                   onPressed: _isChecked
//                       ? () {
//                     print("Form Submitted ✅");
//                   }
//                       : null, // disabled until checked
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.transparent, // 👈 transparent for gradient
//                     shadowColor: Colors.transparent,     // remove default shadow
//                     foregroundColor: Colors.white,       // text color
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: Text(
//                     "Submit",
//                     style: AppTextStyles.button(context)?.copyWith(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white, // white text for contrast
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             // Bottom links
//             SizedBox(height: 60,),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pushNamed(RouteNames.login);
//               },
//               child: Text(
//                 "Existing User? Login",
//                 style: AppTextStyles.link(context)?.copyWith(color: Colors.grey,fontSize: 14,
//                   decoration: TextDecoration.underline, // 👈 optional, makes it look like a link
//                 ),
//               ),
//             ),
//             const SizedBox(height: 120),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// /// ---------------- ROLE FORM ----------------
// class _RoleForm extends StatelessWidget {
//   final String role;
//   const _RoleForm({required this.role});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(
//           "Registering as $role",
//           style: AppTextStyles.body(context)?.copyWith(
//             fontWeight: FontWeight.w600,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 16),
//
//         // SizedBox(
//         //   width: 330,
//         //   child: TextField(
//         //     decoration: InputDecoration(
//         //       hintText: "Full name",
//         //       filled: true,
//         //       fillColor: Colors.grey[100],
//         //       border: OutlineInputBorder(
//         //         borderRadius: BorderRadius.circular(12),
//         //         borderSide: BorderSide(color: Colors.grey.shade300),
//         //       ),
//         //     ),
//         //   ),
//         // ),
//         // const SizedBox(height: 16),
//         //
//         // SizedBox(
//         //   width: 330,
//         //   child: TextField(
//         //     decoration: InputDecoration(
//         //       hintText: "Email",
//         //       filled: true,
//         //       fillColor: Colors.grey[100],
//         //       border: OutlineInputBorder(
//         //         borderRadius: BorderRadius.circular(12),
//         //         borderSide: BorderSide(color: Colors.grey.shade300),
//         //       ),
//         //     ),
//         //   ),
//         // ),
//       ],
//     );
//   }
// }
//
