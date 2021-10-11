import 'package:bloc_test/bloc_test.dart';
import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:projekty/cubit/wake_up_calculator_cubit.dart';

void main() {
  group("wake up calculator cubit", () {
    late WakeUpCalculatorCubit cubit;

    setUp(() {
      Clock testClock = Clock.fixed(DateTime.utc(2021, 10, 10, 20, 30, 0));
      cubit = WakeUpCalculatorCubit(clock: testClock);
    });

    blocTest('init bloc',
        build: () => cubit,
        expect: () => []);
  });
}
