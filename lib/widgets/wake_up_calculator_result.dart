import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projekty/cubit/wake_up_calculator_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WakeUpCalculatorResultWidget extends StatelessWidget {
  final WakeUpCalculatorCubit cubit;

  const WakeUpCalculatorResultWidget({Key? key, required this.cubit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WakeUpCalculatorCubit, WakeUpCalculatorState>(
        bloc: cubit,
        buildWhen: (previous, state) {
          return state is WakeUpCalculatorResult;
        },
        builder: (context, state) {
          if (state is WakeUpCalculatorInitial) return Container();
          state = state as WakeUpCalculatorResult;
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.shouldWake(
                    state.calculatingType == CalculatingType.GoToSleep
                        ? AppLocalizations.of(context)!.wakeUp
                        : AppLocalizations.of(context)!.goToSleep)),
                Builder(builder: (context) {
                  List<Widget> texts = List.generate(4, (index) {
                    return Text(
                        (state as WakeUpCalculatorResult).results[index]);
                  });
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: texts,
                  );
                })
              ],
            ),
          );
        });
  }
}
