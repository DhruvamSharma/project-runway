import 'constants.dart';

String buildLabel(String urgency) {
  int importance = double.parse(urgency).round();
  String importanceText;
  if (importance < 4) {
    importanceText = "Yeah, important!";
  } else if (importance < 7 && importance >= 4) {
    importanceText = "Dang! It's important";
  } else if (importance < 9 && importance >= 7) {
    importanceText = "Get to it!";
  } else {
    importanceText = "You do it RIGHT NOW!";
  }
  return importanceText;
}

int buildUrgency(String urgency) {
  int urgencyInt;
  try {
    urgencyInt = double.parse(urgency).round();
  } catch (ex) {
    urgencyInt = DEFAULT_URGENCY;
  }
  return urgencyInt;
}
