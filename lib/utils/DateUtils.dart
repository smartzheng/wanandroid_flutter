class DateUtils{
  static String formatDate(int time){
    DateTime date = new DateTime(time);
    return "${date.year.toString()}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}";
  }
}