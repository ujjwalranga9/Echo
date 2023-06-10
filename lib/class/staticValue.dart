

class StaticValue {
  static int sleepTimer = 0;
  static double speed = 1.0;
  static double skipAmount = 2.0;

  static Duration stringToDuration(String sleepTimer){

    int val = int.parse(sleepTimer);
    Duration duration = Duration.zero ;
    if(val < 60.0){
      duration = Duration(seconds: val);
    }else{
        int hours  = val~/3600;
        int min = val~/60 - hours*60;

      duration = Duration(hours: hours ,minutes: min);
    }
    return duration;
  }

}