import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/injection_container.dart';
import 'package:project_runway/features/tasks/presentation/manager/bloc.dart';
import 'package:project_runway/features/tasks/presentation/widgets/home_screen/current_task_page.dart';
import 'package:provider/provider.dart';

class TaskPage extends StatelessWidget {
  final int pageNumber;

  TaskPage({
    @required this.pageNumber,
  });
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeScreenTaskBloc>(
      builder: (_) => sl<HomeScreenTaskBloc>(),
      child: BlocBuilder<HomeScreenTaskBloc, TaskBlocState>(
        builder: (_, state) {
          return ChangeNotifierProvider<PageHolderProviderModel>(
            create: (_) => PageHolderProviderModel(pageNumber: pageNumber),
            child: CurrentTaskPage(),
          );
        },
      ),
    );
  }
}

class PageHolderProviderModel extends ChangeNotifier {
  int pageNumber;
  PageHolderProviderModel({
    @required this.pageNumber,
  });
  void assignPageNumber(int newPageNumber) {
    pageNumber = newPageNumber;
  }
}
