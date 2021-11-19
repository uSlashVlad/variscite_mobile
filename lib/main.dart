import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktoast/oktoast.dart';

import 'package:variscite_mobile/bloc/api_cubit.dart';
import 'package:variscite_mobile/presentation/initial_screen/initial_screen.dart';
import 'package:variscite_mobile/presentation/login_screen/login_screen.dart';
import 'package:variscite_mobile/presentation/map_screen/map_screen.dart';
import 'package:variscite_mobile/presentation/user_screen/user_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ApiCubit>(
      create: (context) => ApiCubit(),
      child: OKToast(
        position: ToastPosition.bottom,
        duration: const Duration(seconds: 1),
        child: MaterialApp(
          title: 'Variscite Mobile',
          theme: ThemeData.dark(),
          initialRoute: InitialScreen.route,
          routes: {
            InitialScreen.route: (context) => const InitialScreen(),
            LoginScreen.route: (context) => const LoginScreen(),
            MapScreen.route: (context) => const MapScreen(),
            UserScreen.route: (context) => const UserScreen(),
          },
        ),
      ),
    );
  }
}
