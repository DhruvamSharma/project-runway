import 'package:flutter/material.dart';
import 'package:project_runway/core/analytics_utils.dart';
import 'package:project_runway/core/common_colors.dart';
import 'package:project_runway/core/common_text_styles.dart';
import 'package:project_runway/core/common_ui/custom_snackbar.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/core/theme/theme_model.dart';
import 'package:project_runway/features/tasks/presentation/widgets/home_screen/create_task_shortcut_widget.dart';
import 'package:project_runway/features/tasks/presentation/widgets/home_screen/current_task_page.dart';
import 'package:project_runway/features/tasks/presentation/widgets/home_screen/task_page.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechIcon extends StatefulWidget {
  @override
  _SpeechIconState createState() => _SpeechIconState();
}

class _SpeechIconState extends State<SpeechIcon> {
  final SpeechToText speech = SpeechToText();
  bool _hasSpeech = false;
  bool _startSpeaking = false;
  String lastWords;
  Color progressColor = CommonColors.disabledTaskTextColor;
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ThemeModel>(context, listen: false);
    final pageState =
        Provider.of<PageHolderProviderModel>(context, listen: false);
    final taskListState =
        Provider.of<TaskListHolderProvider>(context, listen: false);
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          iconSize: 21,
          icon: Icon(Icons.mic,
              color: buildIconColor(appState, pageState.pageNumber)),
          onPressed: () async {
            try {
              AnalyticsUtils.sendAnalyticEvent(
                  MIC_SHORTCUT,
                  {
                    "pageNumber": pageState.pageNumber,
                  },
                  "MIC_WIDGET");
            } catch (ex) {}
            if (taskListState.taskList.length <= TOTAL_TASK_CREATION_LIMIT &&
                pageState.pageNumber != 0) {
              try {
                await initSpeechState();
              } catch (ex) {
                // Show error on screen
                showErrorFlow(
                    "Some error occurred, please try again or give the necessary permissions");
              }
            } else {
              Scaffold.of(context).removeCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                CustomSnackbar.withAnimation(
                  context,
                  "You cannot create task for yesterday",
                ),
              );
            }
          },
          tooltip: "Speak to create task",
        ),
        if (_startSpeaking)
          CircularProgressIndicator(
            backgroundColor: progressColor,
          ),
      ],
    );
  }

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(
        debugLogging: true, onError: errorListener, onStatus: statusListener);

    setState(() {
      _hasSpeech = hasSpeech;
      progressColor = CommonColors.chartColor;
    });

    if (!mounted) return;

    if (hasSpeech) {
      speech.listen(onResult: resultListener);
      setState(() {
        _startSpeaking = true;
      });
    } else {
      showErrorFlow("You have denied the use of speech recognition.");
    }
    // some time later...
    Future.delayed(Duration(seconds: 5), () {
      speech.stop();
      setState(() {
        _startSpeaking = false;
        _hasSpeech = false;
        progressColor = CommonColors.disabledTaskTextColor;
      });
    });
  }

  void errorListener(SpeechRecognitionError error) {}

  void statusListener(String status) {}

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      lastWords = "${result.recognizedWords}";
      final response = lastWords;
      if (response != null && response.isNotEmpty) {
        Provider.of<InitialTaskTitleProviderModel>(context, listen: false)
            .assignTaskTitle(response);
      }
    });
  }

  showErrorFlow(String title) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: CommonColors.bottomSheetColor,
            height: 300,
            child: Center(
                child: Text(
              title,
              textAlign: TextAlign.center,
              style: CommonTextStyles.taskTextStyle(context),
            )),
          );
        });
  }
}
