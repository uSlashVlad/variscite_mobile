import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'widgets/import_form_inner.dart';
import 'widgets/import_buttons.dart';

class StructImportScreen extends StatelessWidget {
  /// /main/struct_import
  static String route = '/main/struct_import';

  const StructImportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Import GeoJSON'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: _ImportForm(),
      ),
    );
  }
}

class _ImportForm extends StatelessWidget {
  _ImportForm({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FormBuilder(
          key: _formKey,
          child: const ImportFormInner(),
        ),
        FileLoadingButton(formKey: _formKey),
        AddStructButton(formKey: _formKey),
      ],
    );
  }
}
