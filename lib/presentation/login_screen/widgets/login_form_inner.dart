import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/admin_checkbox_cubit.dart';

class LoginFormInner extends StatelessWidget {
  const LoginFormInner({
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
