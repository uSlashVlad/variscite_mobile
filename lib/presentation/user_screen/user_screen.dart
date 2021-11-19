import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:variscite_mobile/bloc/api_cubit.dart';
import 'package:variscite_mobile/presentation/initial_screen/initial_screen.dart';

class UserScreen extends StatelessWidget {
  /// /main/user
  static String route = '/main/user';

  const UserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Current user'),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: const [_LeaveButton()],
      ),
    );
  }
}

class _LeaveButton extends StatefulWidget {
  const _LeaveButton({Key? key}) : super(key: key);

  @override
  __LeaveButtonState createState() => __LeaveButtonState();
}

class __LeaveButtonState extends State<_LeaveButton> {
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: !isProcessing ? () => _leaveGroup(context) : null,
      child: const Padding(
        padding: EdgeInsets.all(6.0),
        child: Text(
          'Leave group',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  void _leaveGroup(BuildContext context) async {
    setState(() => isProcessing = true);
    final apiC = context.read<ApiCubit>();
    try {
      await apiC.api.deleteCurrentUser();
      await apiC.removeTokenFromStorage();
      Navigator.pushReplacementNamed(context, InitialScreen.route);
    } catch (e) {
      setState(() => isProcessing = false);
      print(e);
    }
  }
}
