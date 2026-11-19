import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stepper_progress_lite/stepper_progress_lite.dart';

Widget _app(Widget child) => MaterialApp(
      home: Scaffold(
          body: Padding(padding: const EdgeInsets.all(16), child: child)),
    );

void main() {
  test('stepStateOf', () {
    expect(stepStateOf(0, 2), StepStatus.done);
    expect(stepStateOf(2, 2), StepStatus.active);
    expect(stepStateOf(3, 2), StepStatus.upcoming);
  });

  testWidgets('done steps show checks, others show numbers', (tester) async {
    await tester.pumpWidget(_app(const StepProgress(
      steps: ['Cart', 'Address', 'Payment', 'Done'],
      current: 2,
    )));
    expect(find.byIcon(Icons.check), findsNWidgets(2));
    expect(find.text('3'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
    expect(find.text('Payment'), findsOneWidget);
  });

  testWidgets('vertical with subtitles and taps', (tester) async {
    int? tapped;
    await tester.pumpWidget(_app(StepProgress(
      steps: const ['Picked up', 'On the way', 'Delivered'],
      subtitles: const ['09:10', '09:45', '—'],
      current: 1,
      direction: Axis.vertical,
      onStepTapped: (i) => tapped = i,
    )));
    expect(find.text('09:45'), findsOneWidget);
    await tester.tap(find.text('Delivered'));
    expect(tapped, 2);
  });
}
