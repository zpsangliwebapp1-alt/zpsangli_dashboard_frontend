// // lib/ui/widgets/ceo_topbar.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../../core/local_provider/local_provider.dart';
//
// class EkatmikYojnaTopBar extends StatelessWidget {
//   const EkatmikYojnaTopBar({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
//       child: Row(
//         children: [
//           const SizedBox(width: 8),
//
//           // 🔍 Search box
//           Expanded(
//             child: Container(
//               height: 48,
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.04),
//                     blurRadius: 6,
//                   )
//                 ],
//               ),
//               child: Row(
//                 children: const [
//                   Icon(Icons.search, color: Colors.grey),
//                   SizedBox(width: 12),
//                   Expanded(
//                     child: TextField(
//                       decoration: InputDecoration.collapsed(
//                         hintText: 'Search here...',
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           const SizedBox(width: 16),
//
//           // 🌐 Language + 🔔 Notification + 👤 Profile
//           Row(
//             children: [
//               Consumer<LocaleProvider>(
//                 builder: (context, localeProvider, _) {
//                   return DropdownButton<Locale>(
//                     value: localeProvider.locale,
//                     underline: const SizedBox(),
//                     icon: const Icon(Icons.language, color: Colors.redAccent),
//                     items: const [
//                       DropdownMenuItem(
//                         value: Locale('en'),
//                         child: Text('English'),
//                       ),
//                       DropdownMenuItem(
//                         value: Locale('mr'),
//                         child: Text('मराठी'),
//                       ),
//                     ],
//                     onChanged: (Locale? locale) {
//                       if (locale != null) {
//                         localeProvider.setLocale(locale);
//                       }
//                     },
//                   );
//                 },
//               ),
//               const SizedBox(width: 12),
//               IconButton(
//                 onPressed: () {},
//                 icon: const Icon(Icons.notifications_none),
//               ),
//               const CircleAvatar(
//                 radius: 18,
//                 backgroundImage: NetworkImage(
//                   'https://i.pravatar.cc/150?img=3',
//                 ),
//               ),
//               const SizedBox(width: 8),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
