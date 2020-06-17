import 'package:project_runway/core/keys/quick_action_keys.dart';
import 'package:quick_actions/quick_actions.dart';

class CustomQuickActions {
  static void initQuickActions(Function onQuickActionTapped) {
    final QuickActions quickActions = QuickActions();
    quickActions.initialize((type) {
      onQuickActionTapped(type);
    });

    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(
          type: VIEW_STATS,
          localizedTitle: 'View Statistics',
          icon: 'stats_quick_action_icon'),
      const ShortcutItem(
          type: CREATE_VISION,
          localizedTitle: 'Create Vision',
          icon: 'vision_board_quick_action_icon'),
      const ShortcutItem(
        type: CREATE_TASK,
        localizedTitle: 'New Task',
        icon: 'add_task_quick_action_icon',
      ),
    ]);
  }
}
