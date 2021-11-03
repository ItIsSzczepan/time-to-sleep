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
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Colors.deepOrangeAccent, Colors.deepOrange],
                  stops: [0.1, 0.9],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.shouldWake(
                        state.calculatingType == CalculatingType.GoToSleep
                            ? AppLocalizations.of(context)!.wakeUp
                            : AppLocalizations.of(context)!.goToSleep),
                    style: const TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(height: 15.0,),
                  Builder(builder: (context) {
                    List<Widget> texts = List.generate(4, (index) {
                      return _resultTimeWidget(context,
                          (state as WakeUpCalculatorResult).results[index]);
                    });
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: texts,
                    );
                  })
                ],
              ),
            ),
          );
        });
  }

  Widget _resultTimeWidget(BuildContext context, String text) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4.0),
        padding: const EdgeInsets.all(6.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0), color: Colors.black26),
        child: Text(text, textScaleFactor: 1.30, textAlign: TextAlign.center,),
      ),
    );
  }
}
