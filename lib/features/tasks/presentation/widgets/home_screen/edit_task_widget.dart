import 'package:flutter/material.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_dimens.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/common_ui/custom_text_field.dart';
import 'package:project_runway/core/date_time_parser.dart';
import 'package:project_runway/core/notifications/local_notifications.dart';
import 'package:project_runway/core/task_utility.dart';
import 'package:project_runway/core/theme/theme_model.dart';
import 'package:project_runway/features/tasks/domain/entities/task_entity.dart';
import 'package:project_runway/features/tasks/presentation/pages/create_task/create_task_page.dart';
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
  bool isNotificationTimeError = false;
  @override
  void initState() {
    taskEntity = widget.task;
    if (checkIsTaskIsOfPast(widget.task.runningDate)) {
      isEnabled = false;
    } else {
      isEnabled = !taskEntity.isCompleted;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ThemeModel>(context, listen: false);
    final taskDetailState =
        Provider.of<TaskDetailProviderModel>(context, listen: false);
    return Builder(
      builder: (newContext) => Padding(
        padding: const EdgeInsets.only(
          top: CommonDimens.MARGIN_20,
        ),
        child: Stack(
          children: <Widget>[
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    top: CommonDimens.MARGIN_20,
                    left: CommonDimens.MARGIN_20,
                    right: CommonDimens.MARGIN_20,
                  ),
                  child: CustomTextField(
                    null,
                    null,
                    enabled: isEnabled,
                    initialText: widget.task.taskTitle,
                    onValueChange: (text) {
                      taskDetailState.assignTaskTitle(text);
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
                    left: CommonDimens.MARGIN_20,
                    right: CommonDimens.MARGIN_20,
                  ),
                  child: CustomTextField(
                    null,
                    null,
                    initialText: widget.task.description,
                    onValueChange: (description) {
                      taskDetailState.assignTaskDescription(description);
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
                    left: CommonDimens.MARGIN_20,
                    right: CommonDimens.MARGIN_20,
                  ),
                  child: CustomTextField(
                    null,
                    null,
                    initialText: widget.task.tag,
                    onValueChange: (tag) {
                      taskDetailState.assignTaskTag(tag);
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
                    top: CommonDimens.MARGIN_40,
                    left: CommonDimens.MARGIN_20,
                    right: CommonDimens.MARGIN_20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Importance",
                        style: CommonTextStyles.disabledTaskTextStyle(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.black,
                          child: Text(
                            double.parse(taskDetailState.urgency)
                                .round()
                                .toString(),
                            style: CommonTextStyles.badgeTextStyle(context)
                                .copyWith(
                                    color: CommonColors.accentColor,
                                    fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: CommonDimens.MARGIN_20 / 4,
                  ),
                  child: SliderTheme(
                    data: SliderThemeData(
                        trackHeight: 5,
                        showValueIndicator: ShowValueIndicator.always,
                        activeTrackColor: CommonColors.chartColor,
                        thumbColor: CommonColors.disabledTaskTextColor,
                        valueIndicatorColor: CommonColors.chartColor,
                        inactiveTrackColor:
                            CommonColors.rotatedDesignTextColor),
                    child: Slider(
                        min: 1,
                        label: buildLabel(taskDetailState.urgency),
                        max: 10,
                        value: double.parse(taskDetailState.urgency),
                        onChanged: isEnabled
                            ? (_) {
                                taskEntity.urgency = _.round();
                                taskDetailState.assignTaskUrgency(_.toString());
                              }
                            : null),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: CommonDimens.MARGIN_20 / 8,
                    left: CommonDimens.MARGIN_20,
                    right: CommonDimens.MARGIN_20,
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.only(top: 10),
                    title: Text(
                      "Notification Time",
                      style:
                          CommonTextStyles.buildNotificationTextColor(context),
                    ),
                    trailing: Text(
                      Provider.of<TaskDetailProviderModel>(newContext,
                                      listen: true)
                                  .notificationTime !=
                              null
                          ? beautifyTime(Provider.of<TaskDetailProviderModel>(
                                  newContext,
                                  listen: false)
                              .notificationTime)
                          : "None",
                      style:
                          CommonTextStyles.buildNotificationTextColor(context),
                    ),
                    onTap: isEnabled
                        ? () {
                            selectTimeForNotification(
                                newContext, widget.task.runningDate, () {
                              setState(() {
                                isNotificationTimeError = true;
                              });
                            }, () {
                              setState(() {
                                isNotificationTimeError = false;
                              });
                            });
                          }
                        : null,
                  ),
                ),
                if (isEnabled && isNotificationTimeError)
                  Text(
                    "You cannot select a time in the past",
                    style: CommonTextStyles.errorFieldTextStyle(),
                  ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: CommonDimens.MARGIN_40,
                    left: CommonDimens.MARGIN_20,
                    right: CommonDimens.MARGIN_20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: CommonDimens.MARGIN_20,
                          ),
                          child: Container(
                            padding: const EdgeInsets.only(
                              top: CommonDimens.MARGIN_20 / 2,
                              bottom: CommonDimens.MARGIN_20,
                            ),
                            alignment: Alignment.center,
                            child: FlatButton(
                                child: Text(
                                  "Delete",
                                  style:
                                      CommonTextStyles.taskTextStyle(context),
                                ),
                                onPressed: () {
                                  taskEntity.isDeleted = true;
                                  Navigator.pop(context, taskEntity);
                                }),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          left: CommonDimens.MARGIN_20,
                        ),
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: CommonDimens.MARGIN_20 / 2,
                            bottom: CommonDimens.MARGIN_20,
                          ),
                          child: MaterialButton(
                            color: appState.currentTheme.accentColor,
                            onPressed: isEnabled
                                ? () {
                                    taskEntity.description =
                                        taskDetailState.description;
                                    taskEntity.urgency =
                                        buildUrgency(taskDetailState.urgency);
                                    taskEntity.taskTitle =
                                        taskDetailState.taskTitle;
                                    taskEntity.tag = taskDetailState.tag;
                                    taskEntity.notificationTime =
                                        taskDetailState.notificationTime;
                                    taskEntity.lastUpdatedAt = DateTime.now();
                                    // schedule the notification
                                    scheduleNotification(
                                      taskEntity.createdAt.toString(),
                                      taskEntity.taskTitle,
                                      taskDetailState.notificationTime,
                                    );
                                    Navigator.pop(context, taskEntity);
                                  }
                                : () {
                                    Navigator.pop(context);
                                  },
                            child: Text(
                              isEnabled ? "Update" : "Go Back",
                              style:
                                  CommonTextStyles.scaffoldTextStyle(context),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: CommonDimens.MARGIN_20,
                  right: CommonDimens.MARGIN_20,
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: CircleAvatar(
                    child: Icon(
                      Icons.clear,
                      color: appState.currentTheme.scaffoldBackgroundColor,
                    ),
                    backgroundColor: appState.currentTheme.accentColor,
                    radius: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
