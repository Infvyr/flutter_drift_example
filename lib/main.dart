import 'package:flutter/material.dart';
import 'package:provider/provider.dart'
    show ChangeNotifierProxyProvider, MultiProvider, Provider;

import 'src/application/index.dart' show AppDb;
import 'src/config/index.dart'
    show AppDarkTheme, AppLightTheme, AppLocaleConfig, RouteGenerator;
import 'src/feature/employee/index.dart' show EmployeeNotifier;
import 'src/utils/index.dart' show GlobalKeys;

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: AppDb()),
        ChangeNotifierProxyProvider<AppDb, EmployeeNotifier>(
          create: (_) => EmployeeNotifier(),
          update: (_, appDb, employeeNotifier) => employeeNotifier!
            ..initAppDb(appDb)
            ..getAllEmployees(),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: GlobalKeys.globalScaffoldKey,
      title: 'Drift Example',
      initialRoute: '/',
      theme: AppLightTheme.lightTheme,
      darkTheme: AppDarkTheme.darkTheme,
      onGenerateRoute: RouteGenerator.generateRoute,
      localizationsDelegates: AppLocaleConfig.localizationsDelegates,
      supportedLocales: AppLocaleConfig.supportedLocales,
      themeAnimationStyle: AnimationStyle(
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 300),
        reverseDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}
