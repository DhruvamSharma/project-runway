DateTime dateParser(String formattedString) {
  DateTime dateTime;
  try {
    dateTime = DateTime.parse(formattedString);
  } catch (ex) {
    dateTime = null;
  }
  return dateTime;
}

String dateToStringParser(DateTime dateTime) {
  String formattedString;
  try {
    formattedString = dateTime.toString();
  } catch (ex) {
    dateTime = null;
  }
  return formattedString;
}
