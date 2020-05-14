import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/common_ui/custom_text_field.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/core/theme/theme_model.dart';
import 'package:project_runway/features/tasks/domain/entities/task_entity.dart';
import 'package:project_runway/features/tasks/presentation/pages/create_task/create_task_page.dart';
import 'package:project_runway/features/tasks/presentation/widgets/home_screen/task_page.dart';
import 'package:provider/provider.dart';

class EditTaskWidget extends StatefulWidget {
  final TaskEntity task;
  EditTaskWidget({
    @required this.task,
  });

  @override
  _EditTaskWidgetState createState() => _EditTaskWidgetState();
}

class _EditTaskWidgetState extends State<EditTaskWidget> {
  bool isEnabled;
  TaskEntity taskEntity;
  @override
  void initState() {
    taskEntity = widget.task;
    if (widget.task.runningDate.day < DateTime.now().day) {
      isEnabled = false;
    } else {
      isEnabled = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (newContext) => Padding(
        padding: const EdgeInsets.all(
          CommonDimens.MARGIN_20,
        ),
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      top: CommonDimens.MARGIN_60,
                    ),
                    child: CustomTextField(
                      null,
                      null,
                      enabled: isEnabled,
                      initialText: widget.task.taskTitle,
                      onValueChange: (text) {
                        Provider.of<TaskDetailProviderModel>(newContext)
                            .assignTaskTitle(text);
                      },
                      label: "Task Title",
                      isRequired: false,
                      onSubmitted: (text) {},
                      errorTextStyle: CommonTextStyles.errorFieldTextStyle(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: CommonDimens.MARGIN_20,
                    ),
                    child: CustomTextField(
                      null,
                      null,
                      initialText: widget.task.description,
                      onValueChange: (description) {
                        Provider.of<TaskDetailProviderModel>(newContext)
                            .assignTaskDescription(description);
                      },
                      label: "Task Description",
                      enabled: isEnabled,
                      isRequired: false,
                      onSubmitted: (text) {},
                      errorTextStyle: CommonTextStyles.errorFieldTextStyle(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: CommonDimens.MARGIN_20,
                    ),
                    child: CustomTextField(
                      null,
                      null,
                      initialText: widget.task.tag,
                      onValueChange: (tag) {
                        Provider.of<TaskDetailProviderModel>(newContext)
                            .assignTaskTag(tag);
                      },
                      label: "Tag",
                      enabled: isEnabled,
                      isRequired: false,
                      onSubmitted: (text) {},
                      errorTextStyle: CommonTextStyles.errorFieldTextStyle(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: CommonDimens.MARGIN_20,
                    ),
                    child: CustomTextField(
                      1,
                      1,
                      initialText: widget.task.urgency.toString(),
                      onValueChange: (urgency) {
                        Provider.of<TaskDetailProviderModel>(newContext)
                            .assignTaskUrgency(urgency);
                      },
                      label: "Urgency",
                      enabled: isEnabled,
                      labelPadding: const EdgeInsets.only(
                          bottom: CommonDimens.MARGIN_20 / 2),
                      isRequired: false,
                      helperText:
                          "Urgency is a number from 0-9 that tells how urgent the task is.",
                      helperTextStyle:
                          CommonTextStyles.badgeTextStyle(context).copyWith(
                        color: Provider.of<ThemeModel>(context).currentTheme.accentColor,
                      ),
                      onSubmitted: (text) {},
                      textFieldValue:
                          Provider.of<TaskDetailProviderModel>(newContext)
                              .urgency,
                      type: TextInputType.phone,
                      textInputFormatter: [
                        LengthLimitingTextInputFormatter(1),
                        WhitelistingTextInputFormatter.digitsOnly,
                      ],
                      errorTextStyle: CommonTextStyles.errorFieldTextStyle(),
                    ),
                  ),
                  if (isEnabled)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: CommonDimens.MARGIN_20,
                            ),
                            child: Container(
                              padding: const EdgeInsets.only(
                                top: CommonDimens.MARGIN_80,
                                bottom: CommonDimens.MARGIN_20,
                              ),
                              alignment: Alignment.center,
                              child: IconButton(
                                  icon: Icon(
                                    Icons.delete_forever,
                                    color: CommonColors.accentColor,
                                  ),
                                  onPressed: () {
                                    taskEntity.isDeleted = true;
                                    Navigator.pop(context, taskEntity);
                                  }),
                            ),
                          ),
                        ),
                        Spacer(),
                        Container(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: CommonDimens.MARGIN_80,
                              bottom: CommonDimens.MARGIN_20,
                            ),
                            child: OutlineButton(
                              onPressed: () {
                                taskEntity.description =
                                    Provider.of<TaskDetailProviderModel>(
                                            newContext)
                                        .description;
                                taskEntity.urgency = buildUrgency(
                                    Provider.of<TaskDetailProviderModel>(
                                            context)
                                        .urgency);
                                taskEntity.taskTitle =
                                    Provider.of<TaskDetailProviderModel>(
                                            newContext)
                                        .taskTitle;
                                taskEntity.tag =
                                    Provider.of<TaskDetailProviderModel>(
                                            context)
                                        .tag;
                                taskEntity.lastUpdatedAt = DateTime.now();
                                Navigator.pop(context, taskEntity);
                              },
                              child: Text(
                                isEnabled ? "Update" : "Go Back",
                                style: CommonTextStyles.taskTextStyle(context),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (!isEnabled)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: CommonDimens.MARGIN_60,
                        ),
                        child: OutlineButton(
                          onPressed: () {
                            Navigator.pop(
                              context,
                            );
                          },
                          child: Text(
                            "Go Back",
                            style: CommonTextStyles.taskTextStyle(context),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int buildUrgency(String urgency) {
    int urgencyInt;
    try {
      urgencyInt = int.parse(urgency);
    } catch (ex) {
      urgencyInt = DEFAULT_URGENCY;
    }
    return urgencyInt;
  }
}
