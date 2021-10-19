import 'package:bloc/bloc.dart';
import 'package:clock/clock.dart';
import 'package:equatable/equatable.dart';

part 'wake_up_calculator_state.dart';

class WakeUpCalculatorCubit extends Cubit<WakeUpCalculatorState> {
  WakeUpCalculatorCubit({required this.clock})
      : super(WakeUpCalculatorInitial()) {
    _time = clock.now();
  }

  final Clock clock;
  HourFormat _hourFormat = HourFormat.h12;
  DateTime _time = DateTime.now();
  CalculatingType _calculatingType = CalculatingType.GoToSleep;

  void changeHourFormat(HourFormat newHourFormat) {
    _hourFormat = newHourFormat;
    _updateState();
  }

  void changeCalculatingType(CalculatingType newCalculatingType) {
    _calculatingType = newCalculatingType;
    _updateState();
  }

  void changeHour(DateTime newTime) {
    _time = newTime;
    _updateState();
  }

  void submit() {
    // TODO: implement this
    throw UnimplementedError();
  }

  List<DateTime> _calculateHour(DateTime time, bool? subtract){
    List<DateTime> list = [];

    for(int i=0; i<4; i++){
      if(subtract ?? false){
        list.add(time.subtract(Duration(minutes: 90*(3+i))));
      }else{
        list.add(time.add(Duration(minutes: 90*(3+i))));
      }
    }

    return list;
  }



  void _updateState() {
    WakeUpCalculatorUpdate newUpdateState =
        WakeUpCalculatorUpdate(_hourFormat, _calculatingType, _time);
    emit(newUpdateState);
  }
}

enum HourFormat { h24, h12 }

enum CalculatingType { GoToSleep, WakeUp }
