# <div align="center">Material State Builder</div>

<div align="center">React to material state changes and offers both the material states and their corresponding controller.</div>

[![coverage][coverage_badge]][coverage_badge]

## Motivation

There is an intrinsic complexity when we need to build a custom widget from a
material widget such as `ElevatedButton`. For example, we need to specify a
`backgroundColor` and an `overlayColor` for the `ElevatedButton` if we want to
set a color when there is no action and another color when the button is pressed
respectively. Even if this could be addressed by setting the color value using
`MaterialStateProperty` there is no easy way to set the same colors for another
widget that wants to react to the same states the button has.

In the following example, there is a `Row` widget with two children: an `Icon`
widget and an `ElevatedButton` widget. In this example we specify the colors the
button has on default state (`Colors.blue`) and when the button is pressed
(`Colors.red`). These two colors correspond to `backgroundColor` and
`overlayColor` respectively. However, we cannot set those colors to the icon
because we have no access to the states of the `ElevatedButton` widget.

```dart
Row(
    children: [
        const Icon(Icons.person, color: Colors.blue),
        ElevatedButton(
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(Colors.blue),
                overlayColor: MaterialStatePropertyAll<Color>(Colors.red),
            ),
            onPressed: () {},
            child: const Text('Press me'),
        ),
    ],
)
```

## Usage

Return the widget you want to react to the material states offered by the
`builder` callback from the `MaterialStateBuilder` widget.

In the following example, we get the same example from the motivation and wrap
the `Row` widget into `MaterialStateBuilder` widget. The `builder` offers the
material state controller and the material states. And now, how do we relate
those states to the `ElevatedButton`? The answer is to set the controller
offered by the builder to the `statesController` property of the
`ElevatedButton`. This way, the body of the `builder` is rebuilt every time the
state of the button changes. Consequently, we can react to the button state
changes for both the `Icon` widget and the `ElevatedButton` itself.

Now we just need to check if the button is pressed and set the color
corresponding to that state to the `color` variable; otherwise, we have set a
default color. The `color` variable is used for both the `Icon` widget and the
`ElevatedButton` widget. Furthermore, we don't need to specify the
`backgroundColor` and the `overlayColor` for `ElevatedButton`, instead, we just
set the `backgroundColor` and the button will change its background color as the
variable `color` changes over the user interaction.

### main.dart

```dart
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
    const MyApp({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Material State Builder Example',
            home: Scaffold(
                body: MaterialStateBuilder(
                    /// Easy way to set the same color for both the icon and the
                    /// button for every button state.
                    builder: (controller, states) {
                        /// Default colot.
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
                ),
            ),
        );
    }
}
```

## Gallery

<p align="center">
  <img width="360" height="140" src="https://github.com/Abel1027/intrinsic-dimension/raw/main/test/goldens/material_state_builder_golden_test.png">
</p>

## Dart Versions

- Dart 2: >= 2.12

## Author

- [Abel Rodríguez](https://github.com/Abel1027)

[coverage_badge]: https://github.com/Abel1027/material_state_builder/raw/main/gallery/coverage_badge.svg
