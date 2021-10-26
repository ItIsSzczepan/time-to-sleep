import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:projekty/cubit/wake_up_calculator_cubit.dart';
import 'package:projekty/screens/home_screen.dart';

void main(){
  group("check if form fields are displaying", (){
    late final baseWidget;

    setUp((){
      baseWidget = MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider(
            create: (BuildContext context) =>
                WakeUpCalculatorCubit(clock: Clock.fixed(DateTime(2021, 10, 10, 20, 30, 0))),
            child: const HomeScreen()),
      );
    });

    testWidgets("check if hours formats are displaying", (WidgetTester tester) async{
      await tester.pumpWidget(baseWidget);

      final findH12 = find.text(AppLocalizationsEn().h12);
      final findH24 = find.text(AppLocalizationsEn().h24);

      expect(findH12, findsOneWidget);
      expect(findH24, findsOneWidget);
    });

    testWidgets("check if \"iWant\" text are displaying", (WidgetTester tester) async{
      await tester.pumpWidget(baseWidget);

      final findIWant = find.text(AppLocalizationsEn().iWant);

      expect(findIWant, findsOneWidget);
    });

    testWidgets("check if actually hour is selected and displaying", (WidgetTester tester) async{
      await tester.pumpWidget(baseWidget);

      final findHour = find.text("20:30");

      expect(findHour, findsOneWidget);
    });

    testWidgets("check if GoToSleepNowButton is displaying", (WidgetTester tester) async{
      await tester.pumpWidget(baseWidget);

      final findHour = find.widgetWithText(TextButton, AppLocalizationsEn().sleepNowButton);

      expect(findHour, findsOneWidget);
    });

  });
}