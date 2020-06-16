bool checkIsTaskIsOfPast(DateTime runningDate) {
  final now = DateTime.now();
  final taskDateTime = runningDate;

  // check for year
  if (taskDateTime.year < now.year) {
    return true;
  } else if (taskDateTime.year > now.year) {
    return false;
  } else {
    // check for month
    if (taskDateTime.month < now.month) {
      return true;
    } else if (taskDateTime.month > now.month) {
      return false;
    } else {
      // check for date
      if (taskDateTime.day < now.day) {
        return true;
      } else {
        return false;
      }
    }
  }
}

// Builds date of the format: 2020-05-17 00:00:00.000
DateTime buildEmptyHMSDate(DateTime dateTime) {
  return DateTime(dateTime.year, dateTime.month, dateTime.day);
}

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
  beautifiedDate =
      "${runningDate.day} ${_monthTranslator(runningDate.month)} ${runningDate.year}";
  return beautifiedDate;
}

beautifyTime(DateTime notificationTime) {
  int hour = notificationTime.hour;
  String timeAsPmOrAm = "AM";
  if (notificationTime.hour > 12) {
    hour = notificationTime.hour - 12;
    timeAsPmOrAm = "PM";
  }
  return "${hour.toString().padLeft(2, "0")}:${notificationTime.minute.toString().padLeft(2, "0")} $timeAsPmOrAm";
}

String _monthTranslator(int month) {
  switch (month) {
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
  switch (weekDay) {
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
