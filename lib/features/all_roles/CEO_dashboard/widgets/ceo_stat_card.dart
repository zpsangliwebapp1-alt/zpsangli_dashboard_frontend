// // lib/ui/widgets/ceo_stat_card.dart
// import 'package:flutter/material.dart';
//
// import '../../../../core/constants/app_fonts.dart';
// import '../../../../core/constants/app_text_styles.dart';
//
// class CeoStatCard extends StatelessWidget {
//   final String title;
//   final String subtitle;
//   // final String hint;
//   final Color color;
//   final Color textColor;
//
//   const CeoStatCard({
//     super.key,
//     required this.title,
//     required this.subtitle,
//     // required this.hint,
//     required this.color,
//     required this.textColor,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(AppSizes.padding),
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title,
//               style: AppTextStyles.headline2(context).copyWith(
//                 color: textColor,
//               )),
//           const SizedBox(height: 4),
//           Text(subtitle, style: AppTextStyles.bodySmall(context)),
//           const SizedBox(height: 6),
//           // Text(
//           //   hint,
//           //   style: AppTextStyles.bodySmall(context).copyWith(
//           //     color: Colors.grey.shade600,
//           //     fontWeight: AppFonts.medium,
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }
// }
//
