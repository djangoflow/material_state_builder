import 'package:flutter/material.dart';
import 'package:material_state_builder/material_state_builder.dart';

main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Example(enabled: true),
    );
  }
}

class Example extends StatelessWidget {
  const Example({
    super.key,
    required this.enabled,
  });

  final bool enabled;

  Color _getColor(Set<MaterialState> states) {
    /// pressed state
    if (states.contains(MaterialState.pressed)) {
      return Colors.red;
    }

    /// default state.
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MaterialStateBuilder(
              /// Easy way to set the same color for both the icon and the
              /// button for every button state.
              builder: (controller, states) {
                final color = _getColor(states);

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
            ),
            const SizedBox(height: 16),
            Row(
              /// This way it's difficult to set the same color for both the
              /// icon and the button for every button state.
              children: [
                const Icon(Icons.person, color: Colors.blue),
                ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(Colors.blue),
                    overlayColor: MaterialStatePropertyAll<Color>(Colors.red),
                  ),
                  onPressed: () {},
                  child: const Text('Press me'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
