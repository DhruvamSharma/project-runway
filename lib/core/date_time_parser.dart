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

String beautifyDate(DateTime runningDate) {
  String beautifiedDate;
  beautifiedDate = "${runningDate.day} ${_monthTranslator(runningDate.month)} ${runningDate.year}";
  return beautifiedDate;
}

String _monthTranslator(int month) {
  switch(month) {
    case 1:
      return "January";
    case 2:
      return "February";
    case 3:
      return "March";
    case 4:
      return "April";
    case 5:
      return "May";
    case 6:
      return "June";
    case 7:
      return "July";
    case 8:
      return "August";
    case 9:
      return "September";
    case 10:
      return "October";
    case 11:
      return "November";
    case 1:
      return "December";
    default:
      return "";
  }
}
