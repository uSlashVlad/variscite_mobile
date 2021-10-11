import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/map_widget.dart';
import 'package:variscite_mobile/bloc/api_cubit.dart';
import 'package:variscite_mobile/utils/geometry/geometry_processing.dart';
import 'package:variscite_mobile/bloc/geometry_cubit.dart';

class MapScreen extends StatelessWidget {
  /// /map
  static const route = '/map';

  const MapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => GeometryCubit(),
        child: Stack(
          children: const [
            InitialLoadingBuilder(),
            MapWidget(),
            // TestApiButton(),
          ],
        ),
      ),
    );
  }
}

class InitialLoadingBuilder extends StatelessWidget {
  const InitialLoadingBuilder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MapGeometryCollection>(
      future: _loadGeometries(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          context.read<GeometryCubit>().replaceGeometry(snapshot.data!);
          return const SizedBox();
        } else {
          return const Align(
            alignment: Alignment.bottomLeft,
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future<MapGeometryCollection> _loadGeometries(BuildContext context) async {
    try {
      MapGeometryCollection? result;

      for (var api in context.read<ApiCubit>().groupsApi) {
        final structs = await api.getAllStructures();
        if (result == null) {
          result = createGeometryCollection(structs);
        } else {
          result.mergeWith(createGeometryCollection(structs));
        }
      }

      return result!;
    } catch (e) {
      print(e);
      return const MapGeometryCollection();
    }
  }
}
