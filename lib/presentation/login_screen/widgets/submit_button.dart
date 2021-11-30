import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:variscite_dart/variscite_dart.dart';

import 'package:variscite_mobile/bloc/api_cubit.dart';
import 'package:variscite_mobile/presentation/common/toasts.dart';

class SubmitButton extends StatefulWidget {
  const SubmitButton({
    Key? key,
    required this.formKey,
  }) : super(key: key);

  final GlobalKey<FormBuilderState> formKey;

  @override
  _SubmitButtonState createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: !isProcessing ? _submitForm : null,
      child: const Padding(
        padding: EdgeInsets.all(6.0),
        child: Text(
          'Submit',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  void _submitForm() async {
    setState(() => isProcessing = true);
    widget.formKey.currentState!.save();
    if (widget.formKey.currentState!.validate()) {
      final data = widget.formKey.currentState!.value;

      final context = widget.formKey.currentContext!;
      final apiC = context.read<ApiCubit>();
      try {
        final userData = await apiC.api.loginUsingInviteCode(
          data['invite_code'],
          UserLoginBody(
            name: data['username'],
            // FIXME here is workaround of quite buggy API - I use ''
            // string instead of null because passcode according to
            // Variscite API specification always must be string.
            // Should delete this workaround after fixing the API.
            passcode: (data['is_admin'] ?? false) ? data['pass_code'] : '',
          ),
        );
        await apiC.loadTokenToStorage(userData.token);
      } catch (e) {
        showError('Login issue happened');
      }
    }
    setState(() => isProcessing = false);
  }
}
