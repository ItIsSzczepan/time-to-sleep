import 'package:bloc/bloc.dart';
import 'package:clock/clock.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

part 'wake_up_calculator_state.dart';

class WakeUpCalculatorCubit extends Cubit<WakeUpCalculatorState> {
  WakeUpCalculatorCubit({required this.clock})
      : super(WakeUpCalculatorInitial()) {
    _time = clock.now();
  }

  final Clock clock;
  HourFormat _hourFormat = HourFormat.h24;
  DateTime _time = DateTime.now();
  CalculatingType _calculatingType = CalculatingType.GoToSleep;

  void changeHourFormat(HourFormat newHourFormat) {
    _hourFormat = newHourFormat;
    _emitUpdateState();
  }

  void changeCalculatingType(CalculatingType newCalculatingType) {
    _calculatingType = newCalculatingType;
    _emitUpdateState();
  }

  void changeHour(DateTime newTime) {
    _time = newTime;
    _emitUpdateState();
  }

  void submit(DateTime? time, CalculatingType? calculatingType) {
    CalculatingType type = calculatingType ?? _calculatingType;

    List<DateTime> dateTimeList = _calculateHour(time ?? _time, type == CalculatingType.WakeUp);
    List<String> hoursList = _convertHoursToString(dateTimeList);
    _emitResultState(hoursList, type);
  }

  void goToSleepNow(){
    submit(_dateTimeNow(), CalculatingType.GoToSleep);
  }


  List<DateTime> _calculateHour(DateTime time, bool? subtract){
    List<DateTime> list = [];

    for(int i=0; i<4; i++){
      if(subtract ?? false){
        list.add(time.subtract(Duration(minutes: 90*(3+i))));
        if(i==3) list = list.reversed.toList();
      }else{
        list.add(time.add(Duration(minutes: 90*(3+i))));
      }
    }

    return list;
  }

  List<String> _convertHoursToString(List<DateTime> list){
    List<String> listToReturn = [];

    list.forEach((element) {
      if (_hourFormat == HourFormat.h12){
        listToReturn.add(DateFormat.jm().format(element));
      }else{
        listToReturn.add(DateFormat.Hm().format(element));
      }
    });

    return listToReturn;
  }

  DateTime _dateTimeNow(){
    return clock.now();
  }

  void _emitUpdateState() {
    WakeUpCalculatorUpdate newUpdateState =
        WakeUpCalculatorUpdate(_hourFormat, _calculatingType, _time);
    emit(newUpdateState);
  }

  void _emitResultState(List<String> list, CalculatingType calculatingType){
    WakeUpCalculatorResult newResultState = WakeUpCalculatorResult(list, calculatingType);
    emit(newResultState);
  }
}

enum HourFormat { h24, h12 }

enum CalculatingType { GoToSleep, WakeUp }
