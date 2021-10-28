import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projekty/cubit/wake_up_calculator_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WakeUpCalculatorForm extends StatelessWidget {
  final WakeUpCalculatorCubit cubit;

  const WakeUpCalculatorForm({Key? key, required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WakeUpCalculatorCubit, WakeUpCalculatorState>(
        bloc: cubit,
        buildWhen: (previous, state) {
          return state is WakeUpCalculatorUpdate ||
              state is WakeUpCalculatorInitial;
        },
        builder: (context, state) {
          List<bool> selectedHourFormatType = [false, true];
          List<bool> selectedCalculatingType = [false, true];
          DateTime time = DateTime(2021);
          HourFormatType hourFormat = HourFormatType.h24;
          CalculatingType calculatingType = CalculatingType.GoToSleep;

          if (state is WakeUpCalculatorInitial) {
            state = (state as WakeUpCalculatorInitial);

            time = state.time;
          } else {
            state = (state as WakeUpCalculatorUpdate);

            time = state.time;
            hourFormat = state.hourFormat;
            calculatingType = state.calculatingType;

            selectedHourFormatType = [
              state.hourFormat == HourFormatType.h12,
              state.hourFormat == HourFormatType.h24
            ];
            selectedCalculatingType = [
              state.calculatingType == CalculatingType.WakeUp,
              state.calculatingType == CalculatingType.GoToSleep
            ];
          }
          return Column(
            children: [
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ToggleButtons(
                      isSelected: selectedHourFormatType,
                      children: [
                        Text(AppLocalizations.of(context)!.h12, key: const Key("h12"),),
                        Text(AppLocalizations.of(context)!.h24, key: const Key("h24"),)
                      ],
                      onPressed: (value) {
                        if (!selectedHourFormatType[value]) {
                          cubit.changeHourFormat(
                              hourFormat ==
                                      HourFormatType.h12
                                  ? HourFormatType.h24
                                  : HourFormatType.h12);
                        }
                      },
                    ),
                    Text(AppLocalizations.of(context)!.iWant),
                    ToggleButtons(
                      isSelected: selectedCalculatingType,
                      children: [
                        Text(AppLocalizations.of(context)!.wakeUp, key: const Key("WakeUpButton")),
                        Text(AppLocalizations.of(context)!.goToSleep, key: const Key("GoToSleepButton"))
                      ],
                      onPressed: (value) {
                        if (!selectedCalculatingType[value]) {
                          cubit.changeCalculatingType(
                              calculatingType ==
                                      CalculatingType.WakeUp
                                  ? CalculatingType.GoToSleep
                                  : CalculatingType.WakeUp);
                        }
                      },
                    ),
                    Text(AppLocalizations.of(context)!.at),
                    TextButton(
                        key: const Key("HourButton"),
                        onPressed: () async {
                          TimeOfDay? newTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                  time));
                          if (newTime != null) {
                            DateTime time = DateTime(
                                2021, 10, 10, newTime.hour, newTime.minute);
                            cubit.changeHour(time);
                          }
                        },
                        child: Text("${time.hour}:${time.minute}")),
                    TextButton(
                        key: const Key("CalculateButton"),
                        onPressed: () => cubit.submit(time, calculatingType),
                        child:
                            Text(AppLocalizations.of(context)!.calculateButton))
                  ],
                ),
              ),
              TextButton(
                key: const Key("SleepNowButton"),
                onPressed: () {
                  cubit.goToSleepNow();
                },
                child: Text(AppLocalizations.of(context)!.sleepNowButton),
              )
            ],
          );
        });
  }
}
