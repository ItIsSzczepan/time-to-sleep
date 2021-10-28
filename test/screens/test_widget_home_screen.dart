import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:projekty/cubit/wake_up_calculator_cubit.dart';
import 'package:projekty/screens/home_screen.dart';

void main(){
  group("check if form fields are displaying", (){
    late final MaterialApp baseWidget;

    setUpAll((){
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

      final findHour = find.widgetWithText(ElevatedButton, AppLocalizationsEn().sleepNowButton);

      expect(findHour, findsOneWidget);
    });

    testWidgets("check if submit button is displaying", (WidgetTester tester) async{
      await tester.pumpWidget(baseWidget);

      final findHour = find.widgetWithText(TextButton, AppLocalizationsEn().calculateButton);

      expect(findHour, findsOneWidget);
    });

  });

  group("interactions tests", ()
  {
    late final MaterialApp baseWidget;

    setUpAll(() {
      baseWidget = MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider(
            create: (BuildContext context) =>
                WakeUpCalculatorCubit(
                    clock: Clock.fixed(DateTime(2021, 10, 10, 20, 30, 0))),
            child: const HomeScreen()),
      );
    });

    testWidgets("check if hour is changed after dismiss", (WidgetTester tester) async{
      await tester.pumpWidget(baseWidget);

      final findHourButton = find.byKey(const Key("HourButton"));
      await tester.tap(findHourButton);
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tapAt(Offset.zero);
      await tester.pump();

      final findSameHourOnButton = find.widgetWithText(TextButton, "20:30");

      expect(findSameHourOnButton, findsOneWidget);
    });

    testWidgets("submit initial", (WidgetTester tester) async{
      await tester.pumpWidget(baseWidget);

      final findCalculateButton = find.byKey(const Key("CalculateButton"));
      await tester.tap(findCalculateButton);
      await tester.pump(const Duration(milliseconds: 2000));

      final findResultText = find.text(AppLocalizationsEn().shouldWake(AppLocalizationsEn().wakeUp));
      final expectValues = ["01:00", "02:30", "04:00", "05:30"];
      List<Finder> founded = [];

      for (var element in expectValues) {founded.add(find.text(element));}

      expect(findResultText, findsOneWidget);
      for (var found in founded){
        expect(found, findsOneWidget);
      }
    });

    testWidgets("test submit after change hour format", (WidgetTester tester) async{
      await tester.pumpWidget(baseWidget);

      final findCalculateButton = find.byKey(const Key("CalculateButton"));
      final findh12 = find.byKey(const Key("h12"));
      await tester.tap(findh12);
      await tester.tap(findCalculateButton);
      await tester.pump(const Duration(milliseconds: 2000));

      final findResultText = find.text(AppLocalizationsEn().shouldWake(AppLocalizationsEn().wakeUp));
      final expectValues = ["1:00 AM", "2:30 AM", "4:00 AM", "5:30 AM"];
      List<Finder> founded = [];

      for (var element in expectValues) {founded.add(find.text(element));}

      expect(findResultText, findsOneWidget);
      for (var found in founded){
        expect(found, findsOneWidget);
      }
    });

    testWidgets("test submit after change type", (WidgetTester tester) async{
      await tester.pumpWidget(baseWidget);

      final findCalculateButton = find.byKey(const Key("CalculateButton"));
      final findWakeUpButton = find.byKey(const Key("WakeUpButton"));
      await tester.tap(findWakeUpButton);
      await tester.pump(const Duration(seconds: 2));
      await tester.tap(findCalculateButton);
      await tester.pump(const Duration(milliseconds: 2000));

      final findResultText = find.text(AppLocalizationsEn().shouldWake(AppLocalizationsEn().goToSleep));
      final expectValues = ["11:30", "13:00", "14:30", "16:00"];
      List<Finder> founded = [];

      for (var element in expectValues) {founded.add(find.text(element));}

      expect(findResultText, findsOneWidget);
      for (var found in founded){
        expect(found, findsOneWidget);
      }
    });

    testWidgets("test sleep now funciton", (WidgetTester tester) async{
      await tester.pumpWidget(baseWidget);

      final findSleepNowButton = find.byKey(const Key("SleepNowButton"));
      await tester.tap(findSleepNowButton);
      await tester.pump(const Duration(milliseconds: 2000));

      final findResultText = find.text(AppLocalizationsEn().shouldWake(AppLocalizationsEn().wakeUp));
      final expectValues = ["01:00", "02:30", "04:00", "05:30"];
      List<Finder> founded = [];

      for (var element in expectValues) {founded.add(find.text(element));}

      expect(findResultText, findsOneWidget);
      for (var found in founded){
        expect(found, findsOneWidget);
      }
    });

  });
}