import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:zp_sangali_dashboard_flutter/features/all_roles/CEO_dashboard/repository/create_bdo_repository.dart';
import 'package:zp_sangali_dashboard_flutter/features/auth/repository/auth_repository.dart';

import 'core/constants/app_theme.dart';
import 'core/constants/splash_screen.dart';
import 'core/local_provider/local_provider.dart';
import 'core/di/injection.dart';
import 'core/network/dio_client.dart';
import 'features/all_roles/CEO_dashboard/provider/broadcast_provider.dart';
import 'features/all_roles/CEO_dashboard/provider/ceo_json_data_provider.dart';
import 'features/all_roles/CEO_dashboard/provider/create_bdo_provider.dart';
import 'features/all_roles/CEO_dashboard/provider/upload_file_provider.dart';
import 'features/all_roles/CEO_dashboard/provider/uploaded_file_list_provider.dart';
import 'features/all_roles/CEO_dashboard/repository/broadcaste_repository.dart';
import 'features/all_roles/CEO_dashboard/repository/ceo_json_data_repository.dart';
import 'features/all_roles/CEO_dashboard/repository/upload_file_repository.dart';
import 'features/all_roles/CEO_dashboard/repository/uploaded_file_list_repository.dart';
import 'features/auth/provider/auth_provider.dart';
import 'features/blocks/provider/block_provider.dart';
import 'features/departments/providers/department_provider.dart';
import 'features/departments/repository/departments_repository.dart';
import 'routing/route_generator.dart';
import 'routing/route_names.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔹 Initialize localization
  await EasyLocalization.ensureInitialized();

  // 🔹 Initialize dependency injection
  await initDependencies();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('mr'),
      ],
      path: 'assets/translations', // folder for en.json & mr.json
      fallbackLocale: const Locale('en'),
      child:  MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  final bdoRepository = BdoRepository(baseUrl: "https://rdprgovapi.atyoureye.com");

  @override
  Widget build(BuildContext context) {
    final dioClient = DioClient();
    final departmentRepo = DepartmentRepository(dioClient);
    final authRepository = AuthRepository(dioClient); // <-- add this
    final broadcastRepo = BroadcastRepository(dioClient: dioClient);


    return MultiProvider(
      providers: [
        /// 🌍 Language Provider (added)
        ChangeNotifierProvider<LocaleProvider>(
          create: (_) => LocaleProvider(),
        ),

        /// 🔐 Authentication
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => getIt<AuthProvider>(),
        ),

        ChangeNotifierProvider(
          create: (context) => DepartmentProvider(
            repository: departmentRepo,
            authProvider: context.read<AuthProvider>(), // ✅ now correct type
          ),
        ),

        ChangeNotifierProvider(create: (_) => CreateBdoProvider(repository: bdoRepository)),

        ChangeNotifierProvider(create: (_) => BroadcastProvider(repository: broadcastRepo)),




        // ChangeNotifierProvider(
        //   create: (_) => CeoDashboardProvider(),
        // ),


        /// 🏗️ Blocks
        ChangeNotifierProvider(
          create: (_) => BdoProvider(
            dio: Dio(
              BaseOptions(baseUrl: 'https://rdprgovapi.atyoureye.com/api'),
            ),
          ),
        ),

        /// 📂 File Upload
        ChangeNotifierProvider(
          create: (_) => UploadFileProvider(
            repository: UploadFileRepository(dioClient: dioClient),
          ),
        ),

        /// 📑 Uploaded Files
        ChangeNotifierProvider(
          create: (_) => UploadedFileProvider(
            repository: UploadedFileRepository(dioClient: dioClient),
          ),
        ),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, _) {
          return MaterialApp(
            title: 'ZP Sangli Dashboard',
            debugShowCheckedModeBanner: false,

            // 🎨 Global theme
            theme: ThemeData(
              fontFamily: GoogleFonts.inter().fontFamily,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),

            // 🌍 Localization setup
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale, // from EasyLocalization

            // 🚀 App routing
            home: const SplashScreen(),
            initialRoute: RouteNames.splash,
            onGenerateRoute: RouteGenerator.generateRoute,
          );
        },
      ),
    );
  }
}
