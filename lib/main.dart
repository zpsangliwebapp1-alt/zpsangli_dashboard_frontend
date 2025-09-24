// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/local_provider/local_provider.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'core/di/injection.dart';
import 'l10n/app_localizations.dart';
import 'routing/route_generator.dart';
import 'routing/route_names.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'package:easy_localization/easy_localization.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await initDependencies();

  runApp(EasyLocalization(
    supportedLocales: [Locale('en'), Locale('mr')],
    path: 'assets/translations', // <-- JSON folder
    fallbackLocale: Locale('en'),

    child: const MyApp(),
  ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'CEO Dashboard - Demo';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => getIt<AuthProvider>(),
        ),
        ChangeNotifierProvider<LocaleProvider>(
          create: (_) => LocaleProvider(),
        ),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp(
            title: _title,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              scaffoldBackgroundColor: const Color(0xFFEFF6F3),
            ),
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale, // EasyLocalization locale
            home: const LoginPage(),
            initialRoute: RouteNames.splash,
            onGenerateRoute: RouteGenerator.generateRoute,
          );

        },
      ),
    );
    ;
  }
}
