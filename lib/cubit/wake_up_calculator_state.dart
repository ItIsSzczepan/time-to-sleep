part of 'wake_up_calculator_cubit.dart';

abstract class WakeUpCalculatorState extends Equatable {
  const WakeUpCalculatorState();
}

class WakeUpCalculatorInitial extends WakeUpCalculatorState {
  final DateTime time;

  const WakeUpCalculatorInitial(this.time);

  @override
  List<Object> get props => [time];
}

class WakeUpCalculatorUpdate extends WakeUpCalculatorState{
  final HourFormat hourFormat;
  final CalculatingType calculatingType;
  final DateTime time;

  const WakeUpCalculatorUpdate(this.hourFormat, this.calculatingType, this.time);

  @override
  List<Object> get props => [hourFormat, calculatingType, time];
}

class WakeUpCalculatorResult extends WakeUpCalculatorState{
  final List<String> results;
  final CalculatingType calculatingType;

  const WakeUpCalculatorResult(this.results, this.calculatingType);

  @override
  List<Object> get props => [results, calculatingType];

}
