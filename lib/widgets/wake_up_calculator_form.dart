import 'dart:ui';

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
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                padding: EdgeInsets.symmetric(vertical: 20.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Colors.indigoAccent, Colors.indigo],
                        stops: [0.1, 0.9])),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ToggleButtons(
                      renderBorder: false,
                      borderRadius: BorderRadius.circular(5.0),
                      fillColor: Colors.deepOrange,
                      selectedColor: Colors.white,
                      isSelected: selectedHourFormatType,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.h12,
                          key: const Key("h12"),
                        ),
                        Text(
                          AppLocalizations.of(context)!.h24,
                          key: const Key("h24"),
                        )
                      ],
                      onPressed: (value) {
                        if (!selectedHourFormatType[value]) {
                          cubit.changeHourFormat(
                              hourFormat == HourFormatType.h12
                                  ? HourFormatType.h24
                                  : HourFormatType.h12);
                        }
                      },
                    ),
                    Text(AppLocalizations.of(context)!.iWant),
                    ToggleButtons(
                      renderBorder: false,
                      borderRadius: BorderRadius.circular(5.0),
                      fillColor: Colors.cyan,
                      selectedColor: Colors.white,
                      isSelected: selectedCalculatingType,
                      children: [
                        Text(AppLocalizations.of(context)!.wakeUp,
                            key: const Key("WakeUpButton")),
                        Text(AppLocalizations.of(context)!.goToSleep,
                            key: const Key("GoToSleepButton"))
                      ],
                      onPressed: (value) {
                        if (!selectedCalculatingType[value]) {
                          cubit.changeCalculatingType(
                              calculatingType == CalculatingType.WakeUp
                                  ? CalculatingType.GoToSleep
                                  : CalculatingType.WakeUp);
                        }
                      },
                    ),
                    Text(AppLocalizations.of(context)!.at),
                    TextButton(
                      style: TextButton.styleFrom(backgroundColor: Colors.white, minimumSize: Size(160.0, 25.0)),
                        key: const Key("HourButton"),
                        onPressed: () async {
                          TimeOfDay? newTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(time));
                          if (newTime != null) {
                            DateTime time = DateTime(
                                2021, 10, 10, newTime.hour, newTime.minute);
                            cubit.changeHour(time);
                          }
                        },
                        child: Text("${time.hour}:${time.minute}", style: TextStyle(fontSize: 20.0),)),
                    TextButton(
                      style: TextButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary, minimumSize: Size(160.0, 25.0), primary: Theme.of(context).colorScheme.onPrimary ),
                        key: const Key("CalculateButton"),
                        onPressed: () => cubit.submit(time, calculatingType),
                        child:
                            Text(AppLocalizations.of(context)!.calculateButton))
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Theme.of(context).colorScheme.secondary, onPrimary: Theme.of(context).colorScheme.onSecondary),
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
