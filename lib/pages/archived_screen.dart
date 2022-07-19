import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';
import '../widgets/custom_widget.dart';

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var tasks = AppCubit.get(context).Archivetasks;
      return TasksBuilder(tasks: tasks);
      },
    );
  }
}