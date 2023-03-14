import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:material_state_builder/material_state_builder.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialStateBuilder(
      /// Easy way to set the same color for both the icon and the
      /// button for every button state.
      builder: (controller, states) {
        /// Default color.
        var color = Colors.blue;
        if (states.contains(MaterialState.pressed)) {
          /// Change color when button is pressed.
          color = Colors.red;
        }

        return Row(
          children: [
            Icon(Icons.person, color: color),
            ElevatedButton(
              statesController: controller,
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(color),
              ),
              onPressed: () {},
              child: const Text('Press me'),
            ),
          ],
        );
      },
    );
  }
}

void main() {
  testGoldens('MaterialStateBuilder', (tester) async {
    final builder = GoldenBuilder.grid(columns: 2, widthToHeightRatio: 1)
      ..addScenario('Default state', const MyApp())
      ..addScenario('Pressed state', const MyApp());

    await tester.pumpWidgetBuilder(
      builder.build(),
      surfaceSize: const Size(360, 140),
    );

    final buttonFinder = find.byType(ElevatedButton);
    await tester.press(buttonFinder.last);

    await screenMatchesGolden(tester, 'material_state_builder_golden_test');
  });
}
