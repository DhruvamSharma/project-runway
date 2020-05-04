import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/common_ui/custom_text_field.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/core/injection_container.dart';
import 'package:project_runway/features/tasks/data/models/task_model.dart';
import 'package:project_runway/features/tasks/domain/entities/task_entity.dart';
import 'package:project_runway/features/tasks/presentation/manager/bloc.dart';

class CreateTaskPage extends StatelessWidget {
  static const String routeName = "${APP_NAME}_v1_task_create-screen";
  final String screenName = "CREATE";
  final DateTime runningDate;
  final String initialTaskTitle;

  CreateTaskPage({
    @required this.runningDate,
    this.initialTaskTitle = "",
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeScreenTaskBloc>(
      builder: (_) => sl<HomeScreenTaskBloc>(),
      child: BlocBuilder<HomeScreenTaskBloc, TaskBlocState>(
        builder: (_, state) => Scaffold(
          appBar: AppBar(
            backgroundColor: CommonColors.appBarColor,
          ),
          body: Builder(
            builder: (newContext) => GestureDetector(
              onDoubleTap: () {
                final task = TaskEntity(
                  userId: "Dhruvam",
                  taskId: "hello",
                  taskTitle: "This is a new task title. A much longer one",
                  description: "This is a beautiful description.",
                  urgency: 3,
                  tag: "architecture",
                  notificationTime: runningDate,
                  createdAt: runningDate,
                  runningDate: runningDate,
                  lastUpdatedAt: runningDate,
                  isSynced: false,
                  isDeleted: false,
                  isMovable: false,
                  isCompleted: false,
                );
                print("task created request");
                BlocProvider.of<HomeScreenTaskBloc>(newContext)
                    .dispatch(CreateTaskEvent(task: task));
              },
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      screenName.toUpperCase(),
                      style: CommonTextStyles.headerTextStyle(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        screenName.toUpperCase(),
                        style: CommonTextStyles.rotatedDesignTextStyle(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: CommonDimens.MARGIN_80 * 2,
                        left: CommonDimens.MARGIN_20,
                        right: CommonDimens.MARGIN_20,
                      ),
                      child: Column(
                        children: <Widget>[
                          CustomTextField(
                            null,
                            null,
                            initialText: initialTaskTitle,
                            onValueChange: (text) {},
                            label: "Task Title",
                            isRequired: true,
                            onSubmitted: (text) {},
                            errorTextStyle:
                                CommonTextStyles.errorFieldTextStyle(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: CommonDimens.MARGIN_40,
                            ),
                            child: CustomTextField(
                              1,
                              1,
                              onValueChange: (text) {},
                              label: "Urgency",
                              labelPadding: const EdgeInsets.only(
                                  bottom: CommonDimens.MARGIN_20 / 2),
                              isRequired: true,
                              onSubmitted: (text) {},
                              type: TextInputType.phone,
                              textInputFormatter: [
                                LengthLimitingTextInputFormatter(1),
                                WhitelistingTextInputFormatter.digitsOnly,
                              ],
                              errorTextStyle:
                                  CommonTextStyles.errorFieldTextStyle(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
