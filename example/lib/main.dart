import 'package:example/tokens.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GeneratedTokenSet selectedSet = GeneratedTokenSet.general;
  Brightness brightness = Brightness.light;

  /// Returns the right theme data based on the selected brightness and token
  /// set.
  ThemeData get themeData {
    if (brightness == Brightness.light) {
      return selectedSet.data.light.themeData;
    } else {
      return selectedSet.data.dark.themeData;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Design token builder Demo',
      theme: themeData,
      home: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: context.colorScheme.primary,
            leading: IconButton(
              icon: Icon(
                brightness == Brightness.light
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
                color: context.colorScheme.onPrimary,
              ),
              onPressed: () {
                final newBrightness = brightness == Brightness.light
                    ? Brightness.dark
                    : Brightness.light;
                setState(() {
                  brightness = newBrightness;
                });
              },
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: DropdownButton<GeneratedTokenSet>(
                  selectedItemBuilder: (context) => GeneratedTokenSet.values
                      .map(
                        (e) => Center(
                          child: Text(
                            e.name,
                            style: context.textTheme.bodyMedium!.copyWith(
                              color: context.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  value: selectedSet,
                  items: GeneratedTokenSet.values
                      .map(
                        (e) => DropdownMenuItem<GeneratedTokenSet>(
                          value: e,
                          child: Text(
                            e.name,
                            style: context.textTheme.bodyMedium!.copyWith(
                              color: context.colorScheme.onBackground,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSet = value!;
                    });
                  },
                ),
              ),
            ],
            title: Text(
              'Demo',
              style: context.textTheme.titleMedium!.copyWith(
                color: context.colorScheme.onPrimary,
              ),
            ),
          ),
          body: ColoredBox(
            color: context.colorScheme.background,
            child: ListView.builder(
              itemCount: textStyles(context).length,
              itemBuilder: (context, index) {
                final textStyle = textStyles(context)[index];
                return Text(
                  textStyle.debugLabel!.split(' ')[1],
                  style: textStyle.copyWith(
                      color: context.colorScheme.onBackground),
                );
              },
            ),
          ),
        );
      }),
    );
  }
}

List<TextStyle> textStyles(BuildContext context) => [
      context.textTheme.displayLarge!,
      context.textTheme.displayMedium!,
      context.textTheme.displaySmall!,
      context.textTheme.titleLarge!,
      context.textTheme.titleMedium!,
      context.textTheme.titleSmall!,
      context.textTheme.bodyLarge!,
      context.textTheme.bodyMedium!,
      context.textTheme.bodySmall!,
      context.textTheme.labelLarge!,
      context.textTheme.labelMedium!,
      context.textTheme.labelSmall!,
    ];
