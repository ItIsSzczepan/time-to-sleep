import 'package:bloc/bloc.dart';
import 'package:clock/clock.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'wake_up_calculator_state.dart';

class WakeUpCalculatorCubit extends Cubit<WakeUpCalculatorState> {
  WakeUpCalculatorCubit({required this.clock}) : super(WakeUpCalculatorInitial());

  final Clock clock;
}

enum HourFormat {
  h24,
  h12
}

enum CalculatingType{
  GoToSleep,
  WakeUp
}
