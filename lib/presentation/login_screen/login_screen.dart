import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'widgets/login_form_inner.dart';
import 'widgets/submit_button.dart';
import 'bloc/admin_checkbox_cubit.dart';

class LoginScreen extends StatelessWidget {
  /// /login
  static const route = '/login';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join the group'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: _LoginForm(),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  _LoginForm({
    Key? key,
  }) : super(key: key);

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FormBuilder(
          key: _formKey,
          child: BlocProvider<AdminCheckBoxCubit>(
            create: (context) => AdminCheckBoxCubit(),
            child: const LoginFormInner(),
          ),
        ),
        const SizedBox(height: 15),
        SubmitButton(formKey: _formKey),
      ],
    );
  }
}
