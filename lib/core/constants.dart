const String APP_NAME = "Runway";

const String USER_NOT_FOUND_ERROR = "Sorry, the data has been corrupted";
const String SAVING_ERROR = "Sorry, could not save your data locally";
const String NO_INTERNET = "Sorry, you don't have a stable internet connection";
const String FIREBASE_ERROR = "Sorry, some database error occurred";
const String NO_NEW_PUZZLE_ERROR = "Sorry, no new puzzle for now";
const String NO_PUZZLE_SOLVED_ERROR = "Sorry, you haven' solved any puzzle";
const String REFRESH_TEXT = "Refreshed the app";

const int DEFAULT_URGENCY = 4;
// All list starts from i = 0 to 6  ==> 7 items
const int TOTAL_TASK_CREATION_LIMIT = 6;
const int TOTAL_VISIONS_LIMIT = 10;

// POINTS
const int TASK_CREATION_POINTS = 10;
const int TASK_DELETION_POINTS = 0;
const int TASK_COMPLETION_POINTS = 20;
const int TASK_MEASUREMENT_DIVISION_CONSTANT = 4;
const int ADD_GOOGLE_SIGN_SCORE = 30;

const int SOLVE_PUZZLE_POINTS = 50;

const int PUZZLE_ID_INCREMENT_NUMBER = 13;

// Notifications
const String TASK_CHANNEL_ID = "TASK_NOTIFICATION";
const String TASK_CHANNEL_NAME = "Task";

// EVENT NAMES
const String SIGN_IN = "sign_in";
const String FOUND_PUZZLE = "found_puzzle";
const String SHARE_LIST = "sharing_task_list";
const String OPEN_SETTINGS = "open_settings";
const String MORE_DETAILS = "more_detail_button";
const String LINK_ACCOUNT = "link_account";
const String SEE_STATS_IN_SETTINGS = "see_stats_in_setting";
const String SEE_STATS_IN_HOME = "see_stats_in_home";
const String THEME_CHANGE = "theme_change";
const String BUG_REPORT = "report_bug";
const String VIEW_APP_TUTORIAL = "view_app_tutorial";
const String SHARE_APP = "share_app";
const String READ_PUZZLE = "read_puzzle";
const String LOG_OUT = "log_out";
const String LEVEL_UP = "puzzle_level_up";
const String CREATE_TASK_SHORTCUT = "create_task_through_shortcut";
const String MIC_SHORTCUT = "create_task_through_mic";
const String DRAW_SHORTCUT = "create_task_through_drawing";
const String DOWNLOAD_VISION_BOARD = "download_vision_board";
