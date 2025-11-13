import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:random_images/business_logic/cubit/random_image_cubit.dart';
import 'package:random_images/core/di/injection_container.dart' as di;
import 'package:random_images/flavor_settings.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:get/get.dart';
import 'package:random_images/navigation_service.dart';
import 'package:random_images/presentation/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies with get_it
  await di.initializeDependencies();

  // Initialize flavor settings
  await FlavorSettings.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Get Cubit from service locator
        BlocProvider<RandomImageCubit>(
          create: (context) => di.sl<RandomImageCubit>(),
        ),
      ],
      child: FlavorBanner(
        child: GetMaterialApp(
          navigatorKey: NavigationService.navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Random Images',
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
          ),
          themeMode: ThemeMode.system,
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
