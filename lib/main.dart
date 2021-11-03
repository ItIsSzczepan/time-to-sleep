import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:projekty/cubit/wake_up_calculator_cubit.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wake Up Calculator',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
            primary: Color.fromRGBO(24, 50, 127, 1.0),
            onPrimary: Colors.white,
            secondary: Color.fromRGBO(34, 60, 137, 1.0),
            onSecondary: Colors.white),
        brightness: Brightness.dark,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider(
          create: (BuildContext context) =>
              WakeUpCalculatorCubit(clock: const Clock()),
          child: const HomeScreen()),
    );
  }
}
