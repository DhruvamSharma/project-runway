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

DateTime buildRunningDate(DateTime currentDate, int pageNumber) {
  DateTime runningDate;
  if (pageNumber == 0) {
    final dateTime = currentDate.subtract(Duration(days: 1));
    runningDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
  } else if (pageNumber == 1) {
    runningDate =
        DateTime(currentDate.year, currentDate.month, currentDate.day);
  } else if (pageNumber == 2) {
    final dateTime = currentDate.add(Duration(days: 1));
    runningDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
  }
  return runningDate;
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

String weekTranslator(int weekDay) {
  switch(weekDay) {
    case 1:
      return "Mon";
    case 2:
      return "Tue";
    case 3:
      return "Wed";
    case 4:
      return "Thu";
    case 5:
      return "Fri";
    case 6:
      return "Sat";
    case 7:
      return "Sun";
    default:
      return "";
  }
}
