import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants/app_theme.dart';
import 'core/di/service_locator.dart';
import 'core/services/firebase_service.dart';
import 'core/widgets/exit_confirmation_wrapper.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/splash/presentation/pages/splash_page.dart';
import 'features/stock/presentation/bloc/stock_event.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Firebase services
  await FirebaseService.initialize();

  // Initialize service locator
  await serviceLocator.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ExitConfirmationWrapper(
      child: MaterialApp(
        title: 'ApniBook Business Manager',
        theme: AppTheme.themeData,
        home: BlocProvider(
          create: (context) =>
              serviceLocator.stockBloc..add(const LoadStocks()),
          child: const SplashPage(),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator.stockBloc..add(const LoadStocks()),
      child: const DashboardPage(),
    );
  }
}
