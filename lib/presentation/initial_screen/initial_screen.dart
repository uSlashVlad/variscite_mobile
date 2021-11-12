import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:variscite_mobile/bloc/api_cubit.dart';
import 'package:variscite_mobile/presentation/map_screen/map_screen.dart';
import 'package:variscite_mobile/presentation/login_screen/login_screen.dart';

class InitialScreen extends StatelessWidget {
  /// /
  static const route = '/';

  const InitialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<ApiCubit>().loadTokenFromStorage();
    return Scaffold(
      body: BlocConsumer<ApiCubit, ApiState>(
        listener: (context, state) {
          if (state is ApiTokenLoaded) {
            // Token nicely loaded
            Navigator.pushReplacementNamed(context, MapScreen.route);
          }
        },
        builder: (context, state) {
          if (state is ApiTokenNotLoaded) {
            // Token does not exist yet
            return SafeArea(child: _firstScreenBuilder(context));
          } else {
            // Token is currently loading
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _firstScreenBuilder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          const Center(
            child: Text(
              'Variscite Mobile',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'Looks like you opened the app for the first time.\n'
            'Join the already created group or create a new one.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, LoginScreen.route);
            },
            child: const Text('Join the group'),
          )
        ],
      ),
    );
  }
}
