import 'package:bloc_test/bloc_test.dart';
import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:projekty/cubit/wake_up_calculator_cubit.dart';

void main() {
  group("wake up calculator cubit", () {
    late WakeUpCalculatorCubit cubit;

    setUp(() {
      Clock testClock = Clock.fixed(DateTime(2021, 10, 10, 20, 30, 0));
      cubit = WakeUpCalculatorCubit(clock: testClock);
    });

    blocTest('init bloc',
        build: () => cubit,
        expect: () => []);

    blocTest('update hour format',
      build: () => cubit,
      act: (cubit) => cubit.changeHourFormat(HourFormat.24),
      expect: () => [WakeUpCalculatorUpdate(HourFormat.24, CalculatingType.GoToSleep, DateTime(2021, 10, 10, 20, 30, 0))],
    );

    blocTest('update calculating type',
      build: () => cubit,
      act: (cubit) => cubit.changeCalculatingType(CalculatingType.WakeUp),
      expect: () => [WakeUpCalculatorUpdate(HourFormat.12, CalculatingType.WakeUp, DateTime(2021, 10, 10, 20, 30, 0))]
    );

    blocTest('update hour',
      build: () => cubit,
      act: (cubit) => cubit.changeHour(DateTime(2021, 10, 10, 21, 0, 0)),
      expect: () => [WakeUpCalculatorUpdate(HourFormat.12, CalculatingType.GoToSleep, DateTime(2021, 10, 10, 21, 0, 0))]
    );

    blocTest('update hour format, calculating type and hour',
      build: () => cubit,
      act: (cubit) => cubit..changeHourFormat(HourFormat.12)..changeCalculatingType(CalculatingType.WakeUp)..changeHour(DateTime(2021, 10, 10, 21, 0, 0)),
      expect: () => [
        WakeUpCalculatorUpdate(HourFormat.12, CalculatingType.GoToSleep, DateTime(2021, 10, 10, 20, 30, 0)),
        WakeUpCalculatorUpdate(HourFormat.12, CalculatingType.WakeUp, DateTime(2021, 10, 10, 20, 30, 0)),
        WakeUpCalculatorUpdate(HourFormat.12, CalculatingType.WakeUp, DateTime(2021, 10, 10, 21, 0, 0))
      ]
    );

    blocTest('submit after init',
      build: () => cubit,
      act: (cubit) => cubit.submit(),
      expect: () => [WakeUpCalculatorResult(["01:00", "02:30", "4:00", "5:30"], CalculatingType.GoToSleep)]
    );

    blocTest('submit 2 times',
        build: () => cubit,
        act: (cubit) => cubit..submit()..submit(),
        expect: () => [
          WakeUpCalculatorResult(["01:00", "02:30", "4:00", "5:30"], CalculatingType.GoToSleep),
          WakeUpCalculatorResult(["01:00", "02:30", "4:00", "5:30"], CalculatingType.GoToSleep)
        ]
    );

    blocTest("submit after init 12 hour format",
      build: () => cubit,
      act: (cubit) => cubit..changeHourFormat(HourFormat.12)..submit(),
      expect: () => [
        WakeUpCalculatorUpdate(HourFormat.12, CalculatingType.GoToSleep, DateTime(2021, 10, 10, 20, 30, 0)),
        WakeUpCalculatorResult(["01:00 AM", "02:30 AM", "4:00 AM", "5:30 AM"], CalculatingType.GoToSleep)
      ]
    );

    blocTest('submit after init with WakeUp type',
      build: () => cubit,
      act: (cubit) => cubit..changeCalculatingType(CalculatingType.WakeUp)..submit(),
      expect: () => [
        WakeUpCalculatorUpdate(HourFormat.24, CalculatingType.WakeUp, DateTime(2021, 10, 10, 20, 30, 0)),
        WakeUpCalculatorResult(["11:30", "13:00", "14:30", "16:00"], CalculatingType.WakeUp)
      ]
    );

    blocTest('submit after init with WakeUp type and 12 hour format',
        build: () => cubit,
        act: (cubit) => cubit..changeCalculatingType(CalculatingType.WakeUp)..changeHourFormat(HourFormat.12)..submit(),
        expect: () => [
          WakeUpCalculatorUpdate(HourFormat.24, CalculatingType.WakeUp, DateTime(2021, 10, 10, 20, 30, 0)),
          WakeUpCalculatorUpdate(HourFormat.12, CalculatingType.WakeUp, DateTime(2021, 10, 10, 20, 30, 0)),
          WakeUpCalculatorResult(["11:30 AM", "01:00 PM", "02:30 PM", "04:00 PM"], CalculatingType.WakeUp)
        ]
    );

    blocTest('submit second time after change inputs',
      build: () => cubit,
      act: (cubit) => cubit..submit()..changeHourFormat(HourFormat.12)..changeCalculatingType(CalculatingType.WakeUp)..changeHour(DateTime(2021, 10, 10, 21, 0, 0))..submit(),
      expect: () => [
        WakeUpCalculatorResult(["01:00", "02:30", "4:00", "5:30"], CalculatingType.GoToSleep),
        WakeUpCalculatorUpdate(HourFormat.12, CalculatingType.GoToSleep, DateTime(2021, 10, 10, 20, 30, 0)),
        WakeUpCalculatorUpdate(HourFormat.12, CalculatingType.WakeUp, DateTime(2021, 10, 10, 20, 30, 0)),
        WakeUpCalculatorUpdate(HourFormat.12, CalculatingType.WakeUp, DateTime(2021, 10, 10, 21, 0, 0)),
        WakeUpCalculatorResult(["12:00 AM", "01:30 PM", "03:00 PM", "04:30 PM"], CalculatingType.WakeUp),
      ]
    );

    blocTest('update data before submit, update data after submit and submit again',
        build: () => cubit,
        act: (cubit) => cubit..changeHourFormat(HourFormat.24)..changeHour(DateTime(2021, 10, 10, 16, 0, 0))..submit()..changeHourFormat(HourFormat.12)..changeCalculatingType(CalculatingType.WakeUp)..changeHour(DateTime(2021, 10, 10, 21, 0, 0))..submit(),
        expect: () => [
          WakeUpCalculatorUpdate(HourFormat.24, CalculatingType.GoToSleep, DateTime(2021, 10, 10, 20, 30, 0)),
          WakeUpCalculatorUpdate(HourFormat.24, CalculatingType.GoToSleep, DateTime(2021, 10, 10, 16, 0, 0)),
          WakeUpCalculatorResult(["20:30", "22:00", "23:30", "1:00"], CalculatingType.GoToSleep),
          WakeUpCalculatorUpdate(HourFormat.12, CalculatingType.GoToSleep, DateTime(2021, 10, 10, 20, 30, 0)),
          WakeUpCalculatorUpdate(HourFormat.12, CalculatingType.WakeUp, DateTime(2021, 10, 10, 20, 30, 0)),
          WakeUpCalculatorUpdate(HourFormat.12, CalculatingType.WakeUp, DateTime(2021, 10, 10, 21, 0, 0)),
          WakeUpCalculatorResult(["12:00 AM", "01:30 PM", "03:00 PM", "04:30 PM"], CalculatingType.WakeUp),
        ]
    );
  });
}
