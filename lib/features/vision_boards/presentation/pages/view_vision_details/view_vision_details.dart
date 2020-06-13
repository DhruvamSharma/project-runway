import 'package:flutter/material.dart';
import 'package:project_runway/core/common_ui/under_maintainance_widget.dart';
import 'package:project_runway/core/constants.dart';
import 'package:project_runway/core/injection_container.dart';
import 'package:project_runway/core/remote_config/remote_config_service.dart';
import 'package:project_runway/features/vision_boards/data/models/vision_model.dart';
import 'package:project_runway/features/vision_boards/presentation/widgets/view_vision_board_details/view_vision_board_details_widget.dart';

class ViewVisionDetailsRoute extends StatelessWidget {
  final VisionModel vision;
  final RemoteConfigService _remoteConfigService = sl<RemoteConfigService>();
  static const String routeName = "${APP_NAME}_v1_vision-board_vision-details";
  ViewVisionDetailsRoute({
    @required this.vision,
  });

  @override
  Widget build(BuildContext context) {
    return buildRoute();
  }

  Widget buildRoute() {
    if (_remoteConfigService.viewVisionBoardDetailEnabled) {
      return ViewVisionBoardDetailsWidget(vision);
    } else {
      return Scaffold(body: UnderMaintenanceWidget());
    }
  }
}

class MarVisionWidgetDirtyModel extends ChangeNotifier {
  bool isDirty = false;
}
