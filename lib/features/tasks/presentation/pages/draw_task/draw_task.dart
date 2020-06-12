import 'package:flutter/material.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/features/tasks/presentation/pages/draw_task/task_painter.dart';
import 'package:provider/provider.dart';

class DrawTaskRoute extends StatelessWidget {
  static const String routeName = "${APP_NAME}_v1_tasks_draw-task";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<DrawingPointsModel>(
        create: (_) => DrawingPointsModel(),
        child: Builder(
          builder: (providerContext) => Stack(
            children: <Widget>[
              GestureDetector(
                onPanUpdate: (dragUpdateDetails) {
                  Provider.of<DrawingPointsModel>(providerContext,
                          listen: false)
                      .assignOffset(dragUpdateDetails.globalPosition);
                },
                onPanStart: (dragUpdateDetails) {
                  Provider.of<DrawingPointsModel>(providerContext,
                          listen: false)
                      .assignOffset(dragUpdateDetails.globalPosition);
                },
                onPanEnd: (dragUpdateDetails) {
                  Provider.of<DrawingPointsModel>(providerContext,
                          listen: false)
                      .assignOffset(null);
                },
                child: Center(
                  child: CustomPaint(
                    painter: TaskPainter(
                        offsets: Provider.of<DrawingPointsModel>(
                      providerContext,
                    ).offsets),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: SizedBox(
                  child: AppBar(
                    backgroundColor: Colors.transparent,
                    actions: <Widget>[
                      IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            Provider.of<DrawingPointsModel>(providerContext,
                                    listen: false)
                                .clearOffsets();
                          })
                    ],
                  ),
                  height: 52,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawingPointsModel extends ChangeNotifier {
  final offsets = <Offset>[];

  assignOffset(Offset offset) {
    offsets.add(offset);
    notifyListeners();
  }

  clearOffsets() {
    offsets.clear();
    notifyListeners();
  }
}
