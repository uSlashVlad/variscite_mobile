import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geojson_vi/geojson_vi.dart';

import 'package:variscite_mobile/bloc/api_cubit.dart';
import 'package:variscite_mobile/bloc/geometry_cubit.dart';
import 'package:variscite_mobile/presentation/common/toasts.dart';

class FileLoadingButton extends StatefulWidget {
  const FileLoadingButton({
    Key? key,
    required this.formKey,
  }) : super(key: key);

  final GlobalKey<FormBuilderState> formKey;

  @override
  _FileLoadingButtonState createState() => _FileLoadingButtonState();
}

class _FileLoadingButtonState extends State<FileLoadingButton> {
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: !isProcessing ? _chooseFile : null,
      child: const Padding(
        padding: EdgeInsets.all(6.0),
        child: Text(
          'Load from file',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  void _chooseFile() async {
    setState(() => isProcessing = true);
    try {
      final result = await FilePicker.platform.pickFiles();
      if (result != null) {
        final pfile = result.files[0];
        final content = await File(pfile.path!).readAsString();

        widget.formKey.currentState!.fields['geojson_text']!.didChange(content);
      } else {
        showError('File wasn\'t choosen');
      }
    } catch (e) {
      showError('Error while file reading occurent');
    }
    setState(() => isProcessing = false);
  }
}

class AddStructButton extends StatefulWidget {
  const AddStructButton({
    Key? key,
    required this.formKey,
  }) : super(key: key);

  final GlobalKey<FormBuilderState> formKey;

  @override
  _AddStructButtonState createState() => _AddStructButtonState();
}

class _AddStructButtonState extends State<AddStructButton> {
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: !isProcessing ? _submitForm : null,
      child: const Padding(
        padding: EdgeInsets.all(6.0),
        child: Text(
          'Add GeoJSON',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  void _submitForm() async {
    setState(() => isProcessing = true);
    widget.formKey.currentState!.save();
    final geojsonText = widget.formKey.currentState!.value['geojson_text'];
    final context = widget.formKey.currentContext!;
    final apiC = context.read<ApiCubit>();
    try {
      final struct = await apiC.api.addNewStructure(
        GeoJSONFeatureCollection.fromJSON(geojsonText),
      );
      final geoC = context.read<GeometryCubit>();
      geoC.addStructure(struct);

      Navigator.pop(context);
    } catch (e) {
      showError('Structure uploading issue happened');
    }
    setState(() => isProcessing = false);
  }
}
