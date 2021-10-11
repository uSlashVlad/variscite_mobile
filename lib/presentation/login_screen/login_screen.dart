import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:variscite_mobile/bloc/api_cubit.dart';

import 'package:variscite_mobile/bloc/login_screen/admin_checkbox_cubit.dart';
import 'package:variscite_mobile/utils/api.dart';

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

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FormBuilder(
          key: _formKey,
          child: BlocProvider<AdminCheckBoxCubit>(
            create: (context) => AdminCheckBoxCubit(),
            child: const _LoginFormInner(),
          ),
        ),
        const SizedBox(height: 15),
        ElevatedButton(
          onPressed: _submitForm,
          child: const Padding(
            padding: EdgeInsets.all(6.0),
            child: Text(
              'Submit',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }

  void _submitForm() async {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      final data = _formKey.currentState!.value;
      print(data);

      final context = _formKey.currentContext!;
      try {
        final userToken = await ApiHandler().login(
          data['invite_code'],
          data['username'],
          data['is_admin'] ? data['pass_code'] : null,
        );
        context.read<ApiCubit>().addApiToken(userToken);
      } catch (e) {
        // TODO show an error
        print(e);
      }
    } else {
      print('Validation failed');
    }
  }
}

class _LoginFormInner extends StatelessWidget {
  const _LoginFormInner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormBuilderTextField(
          name: 'invite_code',
          enableSuggestions: false,
          autocorrect: false,
          decoration: const InputDecoration(
            label: Text('Invite code'),
          ),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.minLength(
              context,
              15,
              errorText: 'Invite code is 15 symbols long',
            ),
            FormBuilderValidators.maxLength(
              context,
              15,
              errorText: 'Invite code is 15 symbols long',
            ),
          ]),
        ),
        FormBuilderTextField(
          name: 'username',
          enableSuggestions: false,
          autocorrect: false,
          decoration: const InputDecoration(
            label: Text('Username'),
          ),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.minLength(
              context,
              3,
              errorText: 'Username should be at least 3 symbol long',
            ),
            FormBuilderValidators.maxLength(
              context,
              30,
              errorText: 'Username shouldn\'t be more than 30 symbols long',
            ),
          ]),
        ),
        FormBuilderCheckbox(
          name: 'is_admin',
          title: const Text(
            'I am an admin!',
            style: TextStyle(fontSize: 15.5),
          ),
          onChanged: context.read<AdminCheckBoxCubit>().changeValue,
        ),
        BlocBuilder<AdminCheckBoxCubit, bool>(builder: (context, state) {
          return state
              ? FormBuilderTextField(
                  name: 'pass_code',
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    label: Text('Admin\'s password'),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.minLength(
                      context,
                      1,
                      errorText: 'Password should be at least 1 symbol long',
                    ),
                    FormBuilderValidators.maxLength(
                      context,
                      40,
                      errorText:
                          'Password shouldn\'t be more than 40 symbols long',
                    ),
                  ]),
                )
              : const SizedBox();
        }),
      ],
    );
  }
}
