import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:variscite_mobile/bloc/api_cubit.dart';
import 'package:variscite_mobile/presentation/map_screen/map_screen.dart';
import 'package:variscite_mobile/presentation/login_screen/login_screen.dart';
import 'package:variscite_mobile/presentation/common/branding.dart';

class InitialScreen extends StatelessWidget {
  /// /
  static const route = '/';

  const InitialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final apiC = context.read<ApiCubit>();
    apiC.loadApis();

    return Scaffold(
      body: BlocConsumer<ApiCubit, ApiState>(
        // If nothing is loaded    -> indicator
        // If tokens are loaded    -> go to map screen
        // If no tokens are loaded -> login buttons
        listener: (context, state) {
          if (state is ApiTokensLoaded && state.loadedCount > 0) {
            print('Going to map!');
            Navigator.pushReplacementNamed(context, MapScreen.route);
          }
        },
        builder: (context, state) {
          print(state);
          if (state is ApiLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ApiTokensLoaded && state.loadedCount == 0) {
            print('First run');
            return SafeArea(child: _firstScreenBuilder(context));
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _firstScreenBuilder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          const Center(child: VarisciteName()),
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
