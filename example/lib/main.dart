import 'package:flutter/material.dart';
import 'package:stepper_progress_lite/stepper_progress_lite.dart';

void main() => runApp(const MaterialApp(home: DemoPage()));

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  int _step = 1;
  static const _steps = ['Cart', 'Address', 'Payment', 'Done'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('stepper_progress_lite')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          StepProgress(
              steps: _steps,
              current: _step,
              onStepTapped: (i) => setState(() => _step = i)),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            OutlinedButton(
                onPressed: _step > 0 ? () => setState(() => _step--) : null,
                child: const Text('Back')),
            const SizedBox(width: 12),
            FilledButton(
                onPressed: _step < _steps.length
                    ? () => setState(() => _step++)
                    : null,
                child: const Text('Next')),
          ]),
          const SizedBox(height: 40),
          const StepProgress(
            direction: Axis.vertical,
            current: 2,
            steps: ['Order placed', 'Picked up', 'On the way', 'Delivered'],
            subtitles: ['09:02', '09:20', 'ETA 10:05', ''],
          ),
        ],
      ),
    );
  }
}
