import 'dart:async';

import 'package:flutter/material.dart';

/// {@template material_state_builder}
/// [MaterialStateBuilder] exposes a [builder] to get the material state of the
/// child widget and its related controller.
///
/// How it works:
///
/// 1. A listener is added to the material state controller.
///
/// 2. The widget is rebuilt every time the material state listener is called
/// and the [builder] offers the new material state along with the corresponding
/// controller.
///
/// Note: You must specify the material state controller provided by the
/// [builder] on the material widget to react to material state changes.
/// In the following example the [controller] exposed by the [builder] is set to
/// the [stateController] property of the [ElevatedButton] widget.
///
/// ```dart
/// MaterialStateBuilder(
///   builder: (controller, states) {
///     var color = Colors.blue;
///     if (states.contains(MaterialState.pressed)) {
///       color = Colors.red;
///     }
///
///     return Row(
///       children: [
///         Icon(Icons.person, color: color),
///         ElevatedButton(
///           statesController: controller,
///           style: ButtonStyle(
///             backgroundColor: MaterialStatePropertyAll<Color>(color),
///             overlayColor: MaterialStatePropertyAll<Color>(color),
///           ),
///           onPressed: () {},
///           child: const Text('Press me'),
///         ),
///       ],
///     );
///   },
/// )
/// ```
/// {@endtemplate}
class MaterialStateBuilder extends StatefulWidget {
  /// {@macro material_state_builder}
  const MaterialStateBuilder({
    key,
    this.statesController,
    required this.builder,
  }) : super(key: key);

  /// Material states controller.
  final MaterialStatesController? statesController;

  /// Builder which exposes the current material states and the corresponding
  /// controller.
  final Widget Function(
    MaterialStatesController controller,
    Set<MaterialState> states,
  ) builder;

  @override
  State<MaterialStateBuilder> createState() => _MaterialStateBuilderState();
}

class _MaterialStateBuilderState extends State<MaterialStateBuilder> {
  MaterialStatesController? internalStatesController;
  MaterialStatesController get statesController =>
      widget.statesController ?? internalStatesController!;
  Timer? timer;

  void onMaterialStateChanged() {
    timer = Timer(Duration.zero, () {
      if (!mounted) return;
      setState(() {});
    });
  }

  void initStatesController() {
    if (widget.statesController == null) {
      internalStatesController = MaterialStatesController();
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      onMaterialStateChanged();
      statesController.addListener(onMaterialStateChanged);
    });
  }

  @override
  void initState() {
    initStatesController();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    statesController
      ..removeListener(onMaterialStateChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder.call(statesController, statesController.value);
  }
}
