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
      act: (cubit) => (cubit as WakeUpCalculatorCubit).changeHourFormat(HourFormat.h24),
      expect: () => [WakeUpCalculatorUpdate(HourFormat.h24, CalculatingType.GoToSleep, DateTime(2021, 10, 10, 20, 30, 0))],
    );

    blocTest('update calculating type',
      build: () => cubit,
      act: (cubit) => (cubit as WakeUpCalculatorCubit).changeCalculatingType(CalculatingType.WakeUp),
      expect: () => [WakeUpCalculatorUpdate(HourFormat.h24, CalculatingType.WakeUp, DateTime(2021, 10, 10, 20, 30, 0))]
    );

    blocTest('update hour',
      build: () => cubit,
      act: (cubit) => (cubit as WakeUpCalculatorCubit).changeHour(DateTime(2021, 10, 10, 21, 0, 0)),
      expect: () => [WakeUpCalculatorUpdate(HourFormat.h24, CalculatingType.GoToSleep, DateTime(2021, 10, 10, 21, 0, 0))]
    );

    blocTest('update hour format, calculating type and hour',
      build: () => cubit,
      act: (cubit) => (cubit as WakeUpCalculatorCubit)..changeHourFormat(HourFormat.h12)..changeCalculatingType(CalculatingType.WakeUp)..changeHour(DateTime(2021, 10, 10, 21, 0, 0)),
      expect: () => [
        WakeUpCalculatorUpdate(HourFormat.h12, CalculatingType.GoToSleep, DateTime(2021, 10, 10, 20, 30, 0)),
        WakeUpCalculatorUpdate(HourFormat.h12, CalculatingType.WakeUp, DateTime(2021, 10, 10, 20, 30, 0)),
        WakeUpCalculatorUpdate(HourFormat.h12, CalculatingType.WakeUp, DateTime(2021, 10, 10, 21, 0, 0))
      ]
    );

    blocTest('submit after init',
      build: () => cubit,
      act: (cubit) => (cubit as WakeUpCalculatorCubit).submit(null, null),
      expect: () => [WakeUpCalculatorResult(["01:00", "02:30", "04:00", "05:30"], CalculatingType.GoToSleep)]
    );

    blocTest('submit 2 times',
        build: () => cubit,
        act: (cubit) => (cubit as WakeUpCalculatorCubit)..submit(null, null)..submit(null, null),
        expect: () => [
          WakeUpCalculatorResult(["01:00", "02:30", "04:00", "05:30"], CalculatingType.GoToSleep),
        ]
    );

    blocTest("submit after init 12 hour format",
      build: () => cubit,
      act: (cubit) => (cubit as WakeUpCalculatorCubit)..changeHourFormat(HourFormat.h12)..submit(null, null),
      expect: () => [
        WakeUpCalculatorUpdate(HourFormat.h12, CalculatingType.GoToSleep, DateTime(2021, 10, 10, 20, 30, 0)),
        WakeUpCalculatorResult(["1:00 AM", "2:30 AM", "4:00 AM", "5:30 AM"], CalculatingType.GoToSleep)
      ]
    );

    blocTest('submit after init with WakeUp type',
      build: () => cubit,
      act: (cubit) => (cubit as WakeUpCalculatorCubit)..changeCalculatingType(CalculatingType.WakeUp)..submit(null, null),
      expect: () => [
        WakeUpCalculatorUpdate(HourFormat.h24, CalculatingType.WakeUp, DateTime(2021, 10, 10, 20, 30, 0)),
        WakeUpCalculatorResult(["11:30", "13:00", "14:30", "16:00"], CalculatingType.WakeUp)
      ]
    );

    blocTest('submit after init with WakeUp type and 12 hour format',
        build: () => cubit,
        act: (cubit) => (cubit as WakeUpCalculatorCubit)..changeCalculatingType(CalculatingType.WakeUp)..changeHourFormat(HourFormat.h12)..submit(null, null),
        expect: () => [
          WakeUpCalculatorUpdate(HourFormat.h24, CalculatingType.WakeUp, DateTime(2021, 10, 10, 20, 30, 0)),
          WakeUpCalculatorUpdate(HourFormat.h12, CalculatingType.WakeUp, DateTime(2021, 10, 10, 20, 30, 0)),
          WakeUpCalculatorResult(["11:30 AM", "1:00 PM", "2:30 PM", "4:00 PM"], CalculatingType.WakeUp)
        ]
    );

    blocTest('submit second time after change inputs',
      build: () => cubit,
      act: (cubit) => (cubit as WakeUpCalculatorCubit)..submit(null, null)..changeHourFormat(HourFormat.h12)..changeCalculatingType(CalculatingType.WakeUp)..changeHour(DateTime(2021, 10, 10, 21, 0, 0))..submit(null, null),
      expect: () => [
        WakeUpCalculatorResult(["01:00", "02:30", "04:00", "05:30"], CalculatingType.GoToSleep),
        WakeUpCalculatorUpdate(HourFormat.h12, CalculatingType.GoToSleep, DateTime(2021, 10, 10, 20, 30, 0)),
        WakeUpCalculatorUpdate(HourFormat.h12, CalculatingType.WakeUp, DateTime(2021, 10, 10, 20, 30, 0)),
        WakeUpCalculatorUpdate(HourFormat.h12, CalculatingType.WakeUp, DateTime(2021, 10, 10, 21, 0, 0)),
        WakeUpCalculatorResult(["12:00 PM", "1:30 PM", "3:00 PM", "4:30 PM"], CalculatingType.WakeUp),
      ]
    );

    blocTest('update data before submit, update data after submit and submit again',
        build: () => cubit,
        act: (cubit) => (cubit as WakeUpCalculatorCubit)..changeHourFormat(HourFormat.h24)..changeHour(DateTime(2021, 10, 10, 16, 0, 0))..submit(null, null)..changeHourFormat(HourFormat.h12)..changeCalculatingType(CalculatingType.WakeUp)..changeHour(DateTime(2021, 10, 10, 21, 0, 0))..submit(null, null),
        expect: () => [
          WakeUpCalculatorUpdate(HourFormat.h24, CalculatingType.GoToSleep, DateTime(2021, 10, 10, 20, 30, 0)),
          WakeUpCalculatorUpdate(HourFormat.h24, CalculatingType.GoToSleep, DateTime(2021, 10, 10, 16, 0, 0)),
          WakeUpCalculatorResult(["20:30", "22:00", "23:30", "01:00"], CalculatingType.GoToSleep),
          WakeUpCalculatorUpdate(HourFormat.h12, CalculatingType.GoToSleep, DateTime(2021, 10, 10, 16, 0, 0)),
          WakeUpCalculatorUpdate(HourFormat.h12, CalculatingType.WakeUp, DateTime(2021, 10, 10, 16, 0, 0)),
          WakeUpCalculatorUpdate(HourFormat.h12, CalculatingType.WakeUp, DateTime(2021, 10, 10, 21, 0, 0)),
          WakeUpCalculatorResult(["12:00 PM", "1:30 PM", "3:00 PM", "4:30 PM"], CalculatingType.WakeUp),
        ]
    );

    blocTest('go to sleep now',
      build: () => cubit,
      act: (cubit) => (cubit as WakeUpCalculatorCubit).goToSleepNow(),
      expect: () => [
        WakeUpCalculatorResult(["01:00", "02:30", "04:00", "05:30"], CalculatingType.GoToSleep),
      ]
    );
  });
}
