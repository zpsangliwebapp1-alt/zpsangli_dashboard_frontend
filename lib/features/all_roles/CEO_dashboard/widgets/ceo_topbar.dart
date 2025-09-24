// lib/ui/widgets/ceo_topbar.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/local_provider/local_provider.dart';

class CeoTopBar extends StatelessWidget {
  const CeoTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange.shade800, // Orange top label background
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: Row(
        children: [
          // 🔹 Logo + App Name
          Row(
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage("assets/images/zillha_parishad_logo.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),


              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "zillaParishadSangliDashboard".tr(), // Replace with your app name
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'Govenrment Of India', // Replace with your app name
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              )

            ],
          ),
          const Spacer(),

          // 🔍 Search box
          Expanded(
            child: Container(
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                  )
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration.collapsed(
                        hintText: 'searchHere'.tr(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 🌐 Language dropdown + 🔔 Notification + 👤 Profile
          Row(
            children: [
              Consumer<LocaleProvider>(
                builder: (context, localeProvider, child) {
                  return DropdownButtonHideUnderline(
                    child: DropdownButton<Locale>(
                      value: context.locale,
                      dropdownColor: Colors.orange.shade800,
                      items: [
                        DropdownMenuItem(
                          value: const Locale('en'),
                          child: Text(
                            'english'.tr(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        DropdownMenuItem(
                          value: const Locale('mr'),
                          child: Text(
                            'मराठी'.tr(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                      onChanged: (Locale? locale) {
                        if (locale != null) context.setLocale(locale);
                      },
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () {},
                tooltip: 'notifications'.tr(),
                icon: const Icon(Icons.notifications_none, color: Colors.white),
              ),
              const CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(
                  'https://i.pravatar.cc/150?img=3',
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}
