import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projekty/cubit/wake_up_calculator_cubit.dart';
import 'package:projekty/widgets/wake_up_calculator_form.dart';
import 'package:projekty/widgets/wake_up_calculator_result.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.info_outline), onPressed: () {  },),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              WakeUpCalculatorForm(cubit: BlocProvider.of<WakeUpCalculatorCubit>(context)),
              WakeUpCalculatorResultWidget(cubit: BlocProvider.of<WakeUpCalculatorCubit>(context))
            ],
          ),
        ),
      ),
    );
  }
}
