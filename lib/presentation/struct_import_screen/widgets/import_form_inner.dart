import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ImportFormInner extends StatelessWidget {
  const ImportFormInner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormBuilderTextField(
          name: 'geojson_text',
          keyboardType: TextInputType.multiline,
          minLines: null,
          maxLines: null,
          // expands: true,
          enableSuggestions: true,
          autocorrect: false,
          decoration: const InputDecoration(
            label: Text('GeoJSON'),
          ),
        ),
      ],
    );
  }
}
