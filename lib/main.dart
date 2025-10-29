import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:dio/dio.dart';

// Core
import 'core/di/injection.dart';
import 'core/local_provider/local_provider.dart';
import 'core/network/dio_client.dart';
import 'core/constants/splash_screen.dart';

// Auth
import 'features/all_roles/CEO_dashboard/provider/bdo_list_provider.dart';
import 'features/all_roles/CEO_dashboard/repository/bdo_list_repository.dart';
import 'features/auth/provider/auth_provider.dart';
import 'features/auth/data/repositories/registration_repository.dart';

// Department
import 'features/departments/providers/department_provider.dart';
import 'features/departments/repository/departments_repository.dart';

// CEO Dashboard
import 'features/all_roles/CEO_dashboard/controller/ceo_dashboard_controller.dart';
import 'features/all_roles/CEO_dashboard/provider/broadcast_provider.dart';
import 'features/all_roles/CEO_dashboard/provider/complaint_provider.dart';
import 'features/all_roles/CEO_dashboard/provider/scheme_provider.dart';
import 'features/all_roles/CEO_dashboard/provider/upload_file_provider.dart';
import 'features/all_roles/CEO_dashboard/provider/uploaded_file_list_provider.dart';
import 'features/all_roles/CEO_dashboard/repository/broadcaste_repository.dart';
import 'features/all_roles/CEO_dashboard/repository/complaint_repository.dart';
import 'features/all_roles/CEO_dashboard/repository/scheme_repository.dart';
import 'features/all_roles/CEO_dashboard/repository/upload_file_repository.dart';
import 'features/all_roles/CEO_dashboard/repository/uploaded_file_list_repository.dart';

// Additional CEO Dashboard
import 'features/all_roles/additional_Ceo_dashboard/provider/additional_ceo_list_provider.dart';
import 'features/all_roles/additional_Ceo_dashboard/repository/additional_ceo_list_repository.dart';

// Blocks
import 'features/blocks/provider/block_provider.dart';



// Routing
import 'routing/route_generator.dart';
import 'routing/route_names.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await initDependencies();

  final dioClient = DioClient();
  await dioClient.initToken(); // ✅ ADD THIS LINE


  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('mr')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Core instances
    final dioClient = DioClient();
    final authProviderInstance = getIt<AuthProvider>();

    // Repository instances
    final departmentRepo = DepartmentRepository(dioClient: dioClient);
    final broadcastRepo = BroadcastRepository(dioClient: dioClient);
    final registrationRepo = RegistrationRepository(dioClient: dioClient);
    final uploadedFileRepo = UploadedFileRepository(dioClient: dioClient);
    final uploadFileRepo = UploadFileRepository(dioClient: dioClient);
    final additionalCeoRepo = AdditionalCeoListRepository(dioClient: dioClient);
    final schemeRepo = SchemeRepository(dioClient: dioClient);
    final bdoListRepo = BdoListRepository(dioClient: dioClient, authProvider: authProviderInstance); // ✅ New

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),

        // ✅ Auth Provider
        ChangeNotifierProvider<AuthProvider>(create: (_) => authProviderInstance),

        // ✅ Department Provider
        ChangeNotifierProvider(
          create: (context) => DepartmentProvider(
            repository: departmentRepo,
            authProvider: context.read<AuthProvider>(),
          ),
        ),

        // ✅ BDO List Provider (NEW)
        ChangeNotifierProvider(
          create: (_) => BdoListProvider(repository: bdoListRepo),
        ),

        // ✅ Other Providers
        ChangeNotifierProvider(
          create: (_) => BroadcastProvider(repository: broadcastRepo),
        ),
        ChangeNotifierProvider(
          create: (_) => UploadFileProvider(repository: uploadFileRepo),
        ),
        ChangeNotifierProvider(
          create: (_) => UploadedFileProvider(repository: uploadedFileRepo),
        ),
        ChangeNotifierProvider(
          create: (_) => AdditionalCeoListProvider(additionalCeoRepo),
        ),
        ChangeNotifierProvider(
          create: (context) => ComplaintProvider(
            repository: ComplaintRepository(
              dioClient: dioClient,
              authProvider: context.read<AuthProvider>(),
            ),
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, SchemeProvider>(
          create: (_) =>
              SchemeProvider(repository: schemeRepo, authProvider: authProviderInstance),
          update: (_, auth, __) =>
              SchemeProvider(repository: schemeRepo, authProvider: auth),
        ),

        // ✅ CEO Dashboard Controller
        ChangeNotifierProxyProvider2<AuthProvider, DepartmentProvider, CeoDashboardController>(
          create: (_) => CeoDashboardController(
            authProvider: authProviderInstance,
            departmentProvider: DepartmentProvider(
              repository: departmentRepo,
              authProvider: authProviderInstance,
            ),
          ),
          update: (_, auth, dept, __) => CeoDashboardController(
            authProvider: auth,
            departmentProvider: dept,
          ),
        ),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, _) {
          return MaterialApp(
            title: 'ZP Sangli Dashboard',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: GoogleFonts.inter().fontFamily,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            home: const SplashScreen(),
            initialRoute: RouteNames.splash,
            onGenerateRoute: RouteGenerator.generateRoute,
          );
        },
      ),
    );
  }
}
